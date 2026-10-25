Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792888357;
	b=PskolegaJ/mFJ1NiaevpytWfmVpfamquFm+K68IsyJ6iSR3IAYWszcejy4fZskrUXrnU
	 qgMTQM5vFjzKxqtG6DPK/MgVGMmudFTSICymWkGEVjhxhArE4zTGILTbHOrbetD+1AHMt
	 ri97iaDGVkgYi/xKg8Q6mGDWfcKqvxYN7M/PrmOAD1CIlCjLHKWSFMuJdtCdPfmLpR5rc
	 Q/HG0neCotwPGf8o1sXKApSKz3SZVQRLV/AbT7THNDv2R/jZ3kFTIDeLk/77JOSFXRmU5
	 owIfUVfA2ifxsfh/AiYisJLn3ZLPeK49WnlvCQTDMt5URuiGVhnVHbe3g4wQ1eOnJGg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792888357;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=/wg1AYBJgVtaq6cKhyF3j3fK2bKAxRc6hRpwyN+2Ncs=;
	b=EHXI9gDECOOTBmhisDsHwP7pJEIpZxDpgV1rZC3rA7zshRt9VSyzbkcwXdgqahJ8bc7d
	 ohHcwFcqQVQBn5dus+3mCiPzwmNLF1bZpQBdAlKXG3f3pe6mwvV+tK6smDl8psFJ1WVY1
	 7/xlNgNuae9mK2tuqYMvia3SEMQaP5E0KAL+v5dtO96Z8IH/xiBUOXeJxZndJuUkIfI9T
	 eOaiqY+vuSQRUaQauFBFDfCYSi/Ls0T/aynGd/9X/jCsC7/TQA7G4s8z3gLnO6fZr79S4
	 piDj5rUxmfrw5UGZMY7vvxt0566PhuUR3gDPdA0+wWmOq/viss84iAnZmy4K0TWhp3Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YmoorK3z;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216C3606A31A;
	Sun, 25 Oct 2026 00:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YmoorK3z
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792888356;
	b=E1FhCY5ESStLDGlXjSHcKs3VKvra1pyTvKEjc8b52z67ZIskAj00AEfG+UsDDmq5ElO8
	 ndEk7TSHu53fMT8XUXVMlPZSb4D1ktgL9EOHds/50MMvhWV/WE3nofC9TKKXRrkp6V9fZ
	 H3gMi+RehCsO8/2jVorF/GEwhPfirxiUp3S7wgF4Darm7RX4opiW4fBCDFwZnxTYRBuFB
	 81H5J05Y3pB2NmFDTnAhV4W/5Ixeb+oIkcTVrUTSE+DrJ0i8g3VCTA8/ijmVa8ciuv18S
	 iJ/EMiW73NCTlTKgZI3FocbdMG3yZ0zmdhD1c+3WBBEK3nQ0MgnL8/MqkmZzLnwNewA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792888356;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=/wg1AYBJgVtaq6cKhyF3j3fK2bKAxRc6hRpwyN+2Ncs=;
	b=i/fvuGjg4RajjkJsgGDV3Nx1TW5N4WYdbNpzikvuvWVMgACjW9hL58AVl+PeDOODseSD
	 7ne1cC8ZRaEwzr4WeosqpCVTf0YfQrBgD0qcJBjkHX8GmmcKy+q6mjKDpLFjyil/+AZa7
	 aScs7ihnhztJAhW8PQLz7lBGTn5F3BshZZ3Zpr0Eh5AqsKl8tNNm0Z+juaXxWynJKnt9O
	 OBpWO0zZ9oxTur6rd0kuVMPf13+SiQwc5rtFJQNOxwZHet9MHrIHIVnbIYwz7DC7lK0nh
	 DUVSmm+r/rGgHPGV5gUVdHc6BP67iSiYET2EwcCG1r9/QCTBxB/DUBpIGwqjb8lXPdQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 30A031F01825;
	Sun, 25 Oct 2026 00:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792888356;
	bh=/wg1AYBJgVtaq6cKhyF3j3fK2bKAxRc6hRpwyN+2Ncs=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=YmoorK3z076iPD80O13vWng2n4IJ8LU6qloTMrgcnTO6M3JcVmvrQJzQyqEAwiJMp
	 aGd21/WuPzHVkMNS8b722W65r1k2JvctL51EjeHaKiX7udBsfuG+kSaxU2gzgmr+NH
	 K3BjYTZEupyZi/wFfTEXHas1ELGhHYfvqVuvIuzTTVempWL+wx+SrTWSoMJVkOsWaA
	 4pBIB4gutiCSPPIewFJL1cOaWBu0QTvvsC7kRVhah0FmdZ94dg9Yt1iWnEas2oQCy9
	 QdsYyLBh/8lOfDWPvWi1Arej6wZyPMhjcD29u/brRD5lf8/fRjfYzgsY1GpaxbhsZT
	 23n0Gr82V33eg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 835CB448FE;
	Sun, 25 Oct 2026 00:32:35 +0000 (UTC)
From: Christopher Griffin via B4 Relay <devnull+christophergriffin05.gmail.com@kernel.org>
Date: Sat, 24 Oct 2026 19:32:35 -0500
Subject: [PATCH ath-next] wifi: ath11k: update rx_channel on a channel
 switch
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
Message-Id: <20261024-ath11k-rx-channel-switch-v1-1-5fc2ba53ca8f@gmail.com>
X-B4-Tracking: v=1; b=H4sIACJO3WoC/yWMywrCMBAAf6Xs2YUk9CH+iniI27XZKlGyUQOl/
 25qj8Mws4ByElY4NQsk/ojKM1awhwYo+DgxylgZnHG9Na5Fn4O1d0wFNx/5gfqVTAFbz6ajwR/
 dQFDzV+KblP/6DLXCyCXDZTf6vs5MeTvDuv4AidJlIYYAAAA=
X-Change-ID: 20261024-ath11k-rx-channel-switch-4ae05c7a827c
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org, 
 linux-kernel@vger.kernel.org, 
 Christopher Griffin <christophergriffin05@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792888354; l=2001;
 i=christophergriffin05@gmail.com; s=20261024; h=from:subject:message-id;
 bh=kTWUZESPAc792VYyFo+r+HGw4s7n/5MRkmKtIAEAtgs=;
 b=vhyYKPGw9EbnJzDdV9aqEFWsjo+UfoGalyF9npk5BmC5+Nej8/Dl7s6197KrPyx2dCKeKoTHE
 TpUmvfL9JLVBd1D2SG9KfcR/JLMxqrrAWJLUffoKzCC8ItdU1HQ+wiv
X-Developer-Key: i=christophergriffin05@gmail.com; a=ed25519;
 pk=oa9tkTNpiGoFWdGvpDHXLSobApmsh9BfrJRJrRJAvWA=
X-Endpoint-Received: by B4 Relay for
 christophergriffin05@gmail.com/20261024 with auth_id=1309
X-Original-From: Christopher Griffin <christophergriffin05@gmail.com>
Reply-To: christophergriffin05@gmail.com
Content-Transfer-Encoding: 7bit

From: Christopher Griffin <christophergriffin05@gmail.com>

ath11k keeps the radio's current channel in ar->rx_channel: survey dumps
flag that channel as in use, and only for it is the bss channel info
requested. ath11k_mac_op_add_chanctx() sets it, but a channel switch
(CSA, or hostapd's switch_chan) goes through ath11k_mac_update_vif_chan(),
which leaves it at the old channel ("TODO: Update ar->rx_channel"). After
a switch the survey keeps marking the old channel as in use and never
refreshes the new one.

Set it to the new context's channel, as ath10k does in its
ath10k_mac_update_vif_chan(). ath11k uses one channel context per radio,
so every vif in the switch moves to the same channel.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Christopher Griffin <christophergriffin05@gmail.com>
---
Found on an Arista C-260 (IPQ8074) while chasing a wrong survey noise
floor; the noise floor fix itself is sent separately ("wifi: ath11k:
report the measured noise floor of the channel in use") and relies on
this one after a channel switch.
---
 drivers/net/wireless/ath/ath11k/mac.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 1a237adaa..57873c875 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -7800,7 +7800,11 @@ ath11k_mac_update_vif_chan(struct ath11k *ar,
 	 * should be available for the channel switch now.
 	 */
 
-	/* TODO: Update ar->rx_channel */
+	if (n_vifs) {
+		spin_lock_bh(&ar->data_lock);
+		ar->rx_channel = vifs[0].new_ctx->def.chan;
+		spin_unlock_bh(&ar->data_lock);
+	}
 
 	for (i = 0; i < n_vifs; i++) {
 		arvif = ath11k_vif_to_arvif(vifs[i].vif);

---
base-commit: cd026e68fdbf88b9cc522b76c7a9d92c9a41f709
change-id: 20261024-ath11k-rx-channel-switch-4ae05c7a827c

Best regards,
--  
Christopher Griffin <christophergriffin05@gmail.com>


