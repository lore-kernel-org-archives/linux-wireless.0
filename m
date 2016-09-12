Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:33381 "EHLO
        mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756419AbcILJnR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 05:43:17 -0400
Received: by mail-pa0-f65.google.com with SMTP id h5so7562821pao.0
        for <linux-wireless@vger.kernel.org>; Mon, 12 Sep 2016 02:43:16 -0700 (PDT)
From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
To: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        johannes.berg@intel.com, hofrat@osadl.org
Cc: prameela.j04cs@gmail.com, prameela.garnepudi@redpinesignals.com
Subject: [PATCH 2/9] rsi: Spelling and code format corrections in rsi_91x_debugfs.c
Date: Mon, 12 Sep 2016 15:08:17 +0530
Message-Id: <0815363e58afd17156b336fe6b06676d6ea707c1.1473669618.git.prameela.j04cs@gmail.com> (sfid-20160912_114327_930488_05CD9614)
In-Reply-To: <cover.1473669618.git.prameela.j04cs@gmail.com>
References: <cover.1473669618.git.prameela.j04cs@gmail.com>
In-Reply-To: <cover.1473669618.git.prameela.j04cs@gmail.com>
References: <cover.1473669618.git.prameela.j04cs@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_debugfs.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_debugfs.c b/drivers/net/wireless/rsi/rsi_91x_debugfs.c
index 828a042..5ec7bce 100644
--- a/drivers/net/wireless/rsi/rsi_91x_debugfs.c
+++ b/drivers/net/wireless/rsi/rsi_91x_debugfs.c
@@ -59,7 +59,7 @@ static int rsi_sdio_stats_read(struct seq_file *seq, void *data)
 }
 
 /**
- * rsi_sdio_stats_open() - This funtion calls single open function of seq_file
+ * rsi_sdio_stats_open() - This function calls single open function of seq_file
  *			   to open file and read contents from it.
  * @inode: Pointer to the inode structure.
  * @file: Pointer to the file structure.
@@ -100,7 +100,7 @@ static int rsi_version_read(struct seq_file *seq, void *data)
 }
 
 /**
- * rsi_version_open() - This funtion calls single open function of seq_file to
+ * rsi_version_open() - This function calls single open function of seq_file to
  *			open file and read contents from it.
  * @inode: Pointer to the inode structure.
  * @file: Pointer to the file structure.
@@ -108,7 +108,7 @@ static int rsi_version_read(struct seq_file *seq, void *data)
  * Return: Pointer to the opened file status: 0 on success, ENOMEM on failure.
  */
 static int rsi_version_open(struct inode *inode,
-				 struct file *file)
+			    struct file *file)
 {
 	return single_open(file, rsi_version_read, inode->i_private);
 }
@@ -180,7 +180,7 @@ static int rsi_stats_read(struct seq_file *seq, void *data)
 }
 
 /**
- * rsi_stats_open() - This funtion calls single open function of seq_file to
+ * rsi_stats_open() - This function calls single open function of seq_file to
  *		      open file and read contents from it.
  * @inode: Pointer to the inode structure.
  * @file: Pointer to the file structure.
@@ -194,7 +194,8 @@ static int rsi_stats_open(struct inode *inode,
 }
 
 /**
- * rsi_debug_zone_read() - This function display the currently enabled debug zones.
+ * rsi_debug_zone_read() - This function display the currently
+ *			enabled debug zones.
  * @seq: Pointer to the sequence file structure.
  * @data: Pointer to the data.
  *
@@ -209,7 +210,7 @@ static int rsi_debug_zone_read(struct seq_file *seq, void *data)
 }
 
 /**
- * rsi_debug_read() - This funtion calls single open function of seq_file to
+ * rsi_debug_read() - This function calls single open function of seq_file to
  *		      open file and read contents from it.
  * @inode: Pointer to the inode structure.
  * @file: Pointer to the file structure.
-- 
2.4.11
