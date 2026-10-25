Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792888383;
	b=yoQxqSu2eh+LEmjQOApA0oX1IMTlHkh5gT4DHckh3sm3gEbYu0uwn+myJccYJ4r5H9bD
	 yV2Sl1NYGaguHsR1kD/QUBnm/I13wCFUYBNltxTeeydcKS9xMq8Lj1irU3ouNyfqJ8HUj
	 KN5N+Rry5tHPar8bQrg7VjugF8OrZ25t2KReAEVyOHZEZhMbpO30INxaJKJskPMLVz5JS
	 YEv4L17XUa6pDRy5xSlGmGKcP2znGsnIBxYCRsOzbUoaZgBQTAF95sZ1sQGCxRW01fZwQ
	 YrTolev5pRJQOUMr/pfnxKTw+0oAAwdLhPMQw1W1/p6scPa4wwwaEHkv422R7OlAnSA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792888383;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=fM3fUjfJbDJMit10qV/pCXS3vPaAmvybkayDS3aKiJU=;
	b=jAi88Fwb+WCK5o6lbz4kwes95yRBzuVtE5i3uXaObUeVJXz3Tm/jkgniBBYeNcrnxYLq
	 pG+N4EnGzRq1NAL5cWwhf07T6jxuJXX9kA5th+P/10VFsR4uXPD+Ow6d0Uo6ewgmb9lZa
	 sr7PTEP8PRBvyTsguqljJozGdn1JJWMi6SNLWfNOUdj5o/TKcSg5Oj2LoRakR7GRN0TGo
	 HYDeB4p5jpPSbPHBYAhpxqo2fqSI2gJ9NCWWYXuXwUQhexNn6ndpZrKo9M43Z1MxRx2IT
	 DxVFUxOdT/Yo7Au7lhOPyWZrRZTKS29OyM4u25HKlmtyhCL2/momcOondX6fSRgaF2Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jxU6RX80;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E43606A31A;
	Sun, 25 Oct 2026 00:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jxU6RX80
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792888382;
	b=TFbtSwoW4pZ6WrMztmIW+Z4alDuH86UrYELU4eisdhIsbYVv701YD/COQWGNL7du7Nv3
	 e68IhOlZyJ7MhyRheQkXOQkpqGrRU7XImxsdegGEnwRXZYiYNam3vUksy+Pai8bNuiU+4
	 pbUbrcer4zFbQMEAJOTB444+KELoSkuFW1PsFwJKcc2qba9YcYiC0qbUlOTXuGypx42oc
	 JRLjhDY3qzYLq0LGjqpH5pU1bjn7Lk1DUqTWH1hkAVnJlRUlTGebZiJNVs4Oq27uxm7bQ
	 gUS6FLwA3zQMzhlYrxPBREiPL3jH7pxTDstPL/NFjP9ege7wFXe7JfmNLbamLnYQwbQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792888382;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=fM3fUjfJbDJMit10qV/pCXS3vPaAmvybkayDS3aKiJU=;
	b=whNZcmhUrRbcq/fvULET1P2CsSHLsm7aNco5JOF0IQCIdgOQcGzganjFchBgNIX0pE0p
	 /2f+SVhb/B2XHhF4dYuMRjl4gYvxR6WNOctfVh/RQQQr0q28L/Yat+XglHYkjb+xD9uz/
	 ITle+BPOKYSHtLL2FyHKrBImu9JuiW9xWGT6qcqCoWGxGeKcUm/XJF5AhZjsjjqu780Uq
	 90yQNc090LGLBpVHpLr6AZ39S6rwFvEs7x1i43CdD8PW3luREFyDg/cZ8d0AJtdpCRRi0
	 UGcI3nt2+6SbKiaeDY7vZRzrtR6XdQUWcmi4UuMnETx70qp3URKqG0z+3IUWf7HTQVA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id E5EA51F031E3;
	Sun, 25 Oct 2026 00:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792888382;
	bh=fM3fUjfJbDJMit10qV/pCXS3vPaAmvybkayDS3aKiJU=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=jxU6RX80El+/x3FYcU0qXnwZvVCufnkGyLyc+bkC2XnSX/zeHRZfqro1qR92tx1Te
	 GYy5PKqySTcnWSmsbkuCOwdoBPa2jNK59j/aY0FpT4Sp7RKkPT19gqsdyM+e7NgkYl
	 qKHmUMaud5x0lva3n1mycgcleyCXMgneLnhKc6lPhjKhNrvNqpQGLcN6o/DTGzPyku
	 HTMDXvOnAMVRUygNtx/FUNYcbn3Nw9fKulMHYQTtYteMuodvxlG8oQq/ouWZLY4OgV
	 f4/3ZDlbrfaF9jIbkUa4DzUbzq1eXpHjvNpe9bUcJRaesvNyDfZHGop6brNNlcSNEz
	 ueGv6SwnNnfeg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 7787E448FE;
	Sun, 25 Oct 2026 00:33:01 +0000 (UTC)
From: Christopher Griffin via B4 Relay <devnull+christophergriffin05.gmail.com@kernel.org>
Date: Sat, 24 Oct 2026 19:33:01 -0500
Subject: [PATCH ath-next] wifi: ath11k: fix beacon stats with more than one
 started vdev
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261024-ath11k-bcn-stats-v1-1-1355f86ec907@gmail.com>
X-B4-Tracking: v=1; b=H4sIADxO3WoC/yWMSwrDMAwFrxK0rsByQxe5SujCH6VRAm6x1BAIu
 Xvddjm8N3OAchVWGLoDKm+i8iwN6NJBmkN5MEpuDN75GznfY7CZaMWYCqoFU3TXKebecY6eoGm
 vypPsv+QI7Y2Fd4P7f9F3XDjZtwjn+QEHglELfgAAAA==
X-Change-ID: 20261024-ath11k-bcn-stats-03fbd40edb21
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org, 
 linux-kernel@vger.kernel.org, 
 Christopher Griffin <christophergriffin05@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792888380; l=3718;
 i=christophergriffin05@gmail.com; s=20261024; h=from:subject:message-id;
 bh=vMs+Yy0kwU5J/ZNugFhL2guGxAJmpSpiZGhMOQQV6/c=;
 b=e+0h242b8f1f3kyTwb1214FNrbc3wtmB5iK/fbrbc8ioniBBRKm6hxrJ6VE2Z0XcAZHZNVQz+
 ZDzCgRu+0LdBLct259/0Jy0o0uledG+ZV8FRx4tPrCppH+yDA42QXLZ
X-Developer-Key: i=christophergriffin05@gmail.com; a=ed25519;
 pk=oa9tkTNpiGoFWdGvpDHXLSobApmsh9BfrJRJrRJAvWA=
X-Endpoint-Received: by B4 Relay for
 christophergriffin05@gmail.com/20261024 with auth_id=1309
X-Original-From: Christopher Griffin <christophergriffin05@gmail.com>
Reply-To: christophergriffin05@gmail.com
Content-Transfer-Encoding: 7bit

From: Christopher Griffin <christophergriffin05@gmail.com>

ath11k_open_bcn_stats() requests beacon stats one vdev at a time, and
ath11k_mac_fw_stats_request() waits for fw_stats_done after each
request. ath11k_debugfs_fw_stats_process() completes fw_stats_done only
once num_bcn_recvd reaches num_started_vdevs, but every request resets
num_bcn_recvd first. With more than one started vdev the count is never
reached, the first request times out, and reading fw_stats/beacon_stats
fails with -ETIMEDOUT.

Complete fw_stats_done on each beacon stats reply and drop
num_bcn_recvd, as ath12k does since commit 2977567b244f ("wifi: ath12k:
Fix timeout error during beacon stats retrieval").

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1

Fixes: 9f6e82d11bb9 ("wifi: ath11k: avoid burning CPU in ath11k_debugfs_fw_stats_request()")
Fixes: 2bcf73b2612d ("wifi: ath11k: don't use static variables in ath11k_debugfs_fw_stats_process()")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Christopher Griffin <christophergriffin05@gmail.com>
---
Found on an Arista C-260 (IPQ8074), where reading beacon_stats failed
on both radios, each running four BSSes.
---
 drivers/net/wireless/ath/ath11k/core.h    |  1 -
 drivers/net/wireless/ath/ath11k/debugfs.c | 12 +++---------
 drivers/net/wireless/ath/ath11k/mac.c     |  1 -
 3 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/core.h b/drivers/net/wireless/ath/ath11k/core.h
index a0d725923..9be0259e7 100644
--- a/drivers/net/wireless/ath/ath11k/core.h
+++ b/drivers/net/wireless/ath/ath11k/core.h
@@ -616,7 +616,6 @@ struct ath11k_fw_stats {
 	struct list_head vdevs;
 	struct list_head bcn;
 	u32 num_vdev_recvd;
-	u32 num_bcn_recvd;
 };
 
 struct ath11k_dbg_htt_stats {
diff --git a/drivers/net/wireless/ath/ath11k/debugfs.c b/drivers/net/wireless/ath/ath11k/debugfs.c
index 70922612d..3e4375715 100644
--- a/drivers/net/wireless/ath/ath11k/debugfs.c
+++ b/drivers/net/wireless/ath/ath11k/debugfs.c
@@ -97,7 +97,6 @@ void ath11k_debugfs_add_dbring_entry(struct ath11k *ar,
 void ath11k_debugfs_fw_stats_process(struct ath11k *ar, struct ath11k_fw_stats *stats)
 {
 	struct ath11k_base *ab = ar->ab;
-	bool is_end = true;
 
 	/* WMI_REQUEST_PDEV_STAT, WMI_REQUEST_RSSI_PER_CHAIN_STAT and
 	 * WMI_REQUEST_VDEV_STAT requests have been already processed.
@@ -107,18 +106,13 @@ void ath11k_debugfs_fw_stats_process(struct ath11k *ar, struct ath11k_fw_stats *
 			ath11k_warn(ab, "empty bcn stats");
 			return;
 		}
-		/* Mark end until we reached the count of all started VDEVs
-		 * within the PDEV
+		/* ath11k_open_bcn_stats() requests one vdev's beacon stats at
+		 * a time, so one reply ends a request.
 		 */
-		if (ar->num_started_vdevs)
-			is_end = ((++ar->fw_stats.num_bcn_recvd) ==
-				  ar->num_started_vdevs);
-
 		list_splice_tail_init(&stats->bcn,
 				      &ar->fw_stats.bcn);
 
-		if (is_end)
-			complete(&ar->fw_stats_done);
+		complete(&ar->fw_stats_done);
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 1a237adaa..74ecf4661 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -4059,7 +4059,6 @@ static void ath11k_mac_fw_stats_reset(struct ath11k *ar)
 	ath11k_fw_stats_pdevs_free(&ar->fw_stats.pdevs);
 	ath11k_fw_stats_vdevs_free(&ar->fw_stats.vdevs);
 	ar->fw_stats.num_vdev_recvd = 0;
-	ar->fw_stats.num_bcn_recvd = 0;
 	spin_unlock_bh(&ar->data_lock);
 }
 

---
base-commit: cd026e68fdbf88b9cc522b76c7a9d92c9a41f709
change-id: 20261024-ath11k-bcn-stats-03fbd40edb21

Best regards,
--  
Christopher Griffin <christophergriffin05@gmail.com>


