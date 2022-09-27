#!/bin/sh
#
#SBATCH --job-name=treemix              # Job Name
#SBATCH --nodes=1             # 40 nodes
#SBATCH --ntasks-per-node=1               # 40 CPU allocation per Task
#SBATCH --partition=sixhour            # Name of the Slurm partition used
#SBATCH --chdir=/home/d669d153/work/hipposideros/treemix    # Set working d$
#SBATCH --mem-per-cpu=2000           # memory requested
#SBATCH --time=360

#convert vcf into treemix file
/home/d669d153/work/stacks-2.41/populations --in_vcf unlinked.filtered.vcf -O . --treemix -M pops.popmap.txt
#remove stacks header and standardize filename
echo "$(tail -n +2 unlinked.filtered.p.treemix)" > unlinked.filtered.recode.p.treemix
#gzip file for input to treemix
gzip unlinked.filtered.recode.p.treemix

#run treemix with m0
/panfs/pfs.local/work/bi/bin/treemix-1.13/src/treemix -i unlinked.filtered.recode.p.treemix.gz -root diadema_PNG -o treem0

#add 1 migration edge
/panfs/pfs.local/work/bi/bin/treemix-1.13/src/treemix -i unlinked.filtered.recode.p.treemix.gz -m 1 -g treem0.vertices.gz treem0.edges.gz -o treem1

#add 2 migration edges
/panfs/pfs.local/work/bi/bin/treemix-1.13/src/treemix -i unlinked.filtered.recode.p.treemix.gz -m 1 -g treem1.vertices.gz treem1.edges.gz -o treem2

#add 3 migration edges
/panfs/pfs.local/work/bi/bin/treemix-1.13/src/treemix -i unlinked.filtered.recode.p.treemix.gz -m 1 -g treem2.vertices.gz treem2.edges.gz -o treem3

#add 4 migration edges
/panfs/pfs.local/work/bi/bin/treemix-1.13/src/treemix -i unlinked.filtered.recode.p.treemix.gz -m 1 -g treem3.vertices.gz treem3.edges.gz -o treem4

#add 5 migration edges
/panfs/pfs.local/work/bi/bin/treemix-1.13/src/treemix -i unlinked.filtered.recode.p.treemix.gz -m 1 -g treem4.vertices.gz treem4.edges.gz -o treem5

