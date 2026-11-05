Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793902302;
	b=KGsIBqUhLbJoimFvhGnxPztW/GR9j3qtyMRQflCjD+8irwhDEVWKGMjSzgHsK7Vg8Gu6
	 79KCfExIPZIoumjZTusLz7eAH0KZFNie0jeXqIQdDNOCNmA1axedo7nj1IJ78VpNXTjDi
	 3W92i7S2Q7YLSu6S/wsgRi9mVtmzAETVIFp56+VeUx0uSonk2cTvwFuEZECCECTymvER5
	 4eCIIBd0k5VbzKoW/OwotjDTnmVAmyElF9p6/nnzFxcC9hkOGJwrnQhMYUN7zmGNiljyG
	 tDkkSWRDxCXYybGsB27A17nBedzFy2PGqW4iX6Iz+NXUAJBcPdQ/KTfn2+zmHegj7Qg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793902302;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=c+tJig5xb24t0XVZzwp57K8cfpDhjN9MmR0cfzYiA9k=;
	b=LxR1XodnpzHFTDNFtOML/D3frpJ4xt1zm/oUrOeaOFFYUtt2UoDpcPv5BtZViedpP9R2
	 iMNVIIZ4qmR4taCXVQEHOmNNAo7uLpEZWiMzI3JKjbDkA69nVSz8ORjKj1S9nBJRPGnq+
	 NEpT74ej8VvSTRmmVQct1YW146ZLevhf6D6UQ2fhCIeHmpuk22XAYcNA8fZZzW/EohpJ3
	 HvQUywibM3679Jv6EjF2ixE2X47WlxsBuS6JzzbQj0PqeIbgLCpp0mPwGCEOk5IlV3mbL
	 cEswFrvitoqk0Nz6RTWjuR12XgpA/UVxvvf/Jjax4b9Pc3kMoQB/Lwi63gvqiEX2EEw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SIDCbA0p;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F793606A31B;
	Thu,  5 Nov 2026 18:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SIDCbA0p
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793902302;
	b=Ny0Gf+M8GbBe/xXqw9sIekWEVUxvxJO3pJ7MQT7igT+F9XQr3GXokyaUn4KJVge/FMRg
	 d8slm06BqsHEJ5c8Gx2pSrvnlnn05PEQ1vQsKa8MaZe121xTXkJJ+ttCeJFpFsZP7QvjV
	 /wrjaTIV0xbGpJTgTYVHX6isIy0Ljbx2FACGejr4ItVByiK1O1WcIhZDPPkkHVnmXqoCj
	 nikzB8cf3O3w5d1DELkWaH0DI8DH68p0BeTnSazcZnbXJACSLPn0nlmY+2AprwsOu0OIA
	 Sftd7CmpWmw/lZGsSUH1EkB/MR9TLD3ueMZQBipV/F6TDwBRumUF8vnH8KrBj85s1Xg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793902302;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=c+tJig5xb24t0XVZzwp57K8cfpDhjN9MmR0cfzYiA9k=;
	b=hHcuopev3WfpZa+97zWm1z2GrBULr/cWyjd7uIRGU2Jl2h8HBYTkLEAvevjgppyylxWb
	 RAPbHeoB6ZY17rV6W0D+bOvYrSqgzLYI46brFNjEgW1UuientEYi6cxjKCIok1/YW7Nxc
	 eZbiqX6SDXmTrcY35PMXe9DLicKSddKAgiD2G/9hW9mdOlGDxHZ6lLQLFvqLdgDtR4oiD
	 3Bp9e9xztfQMTdPtZXSKwe4rCUz2pxdBDwtGm2FBz+x0EJer5oxCvFAA2IvptMRXJ9A+t
	 U6EgCLNy2Q6ySBte8mN/t+P1gTxKKN+iCqUyxY1Aa0oNZPGt2aSGN1+LBau5ZH6HOHQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 946A61F00A02;
	Thu,  5 Nov 2026 18:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793902302;
	bh=c+tJig5xb24t0XVZzwp57K8cfpDhjN9MmR0cfzYiA9k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=SIDCbA0p3X4cLq3yGm5Ey8gn21t9YRlBbC2r1LrD96kWZNolqLBAqYQLcRQ30zMWQ
	 c7tcbd8G/MMIteCnmG77hQOlUs2SSCgR1BJuNMsiAfSaNAGguh4RDzrqjuyoVj3EkX
	 53aLDeeoSBqe/LSNNhpX6mdd4jyXYsX1YA2qf5oGBL7005RZujqIvVjvqnsA2V6u99
	 T+OmVBIAniiSFPa3CXubQnLCNEMTbAKGAenfw1wGS7dwdJJzQitr6L4f11pxy18EaR
	 BPh0fqc+JMJtl9HEtnVIYmQZa3iaRo4cvmp6RSNuJtMkT8czQCcNYlBULpG+izW8SE
	 08ayAVxWpq5ow==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 20A8F473BD;
	Thu,  5 Nov 2026 18:11:40 +0000 (UTC)
From: Christopher Griffin via B4 Relay <devnull+christophergriffin05.gmail.com@kernel.org>
Date: Thu, 05 Nov 2026 12:11:38 -0600
Subject: [PATCH 3/3] wifi: ath10k: don't arm the scan timeout for a scan
 that did not start
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
Message-Id: <20261105-ath-recovery-scan-timeout-v1-3-99a70d89e114@gmail.com>
References: <20261105-ath-recovery-scan-timeout-v1-0-99a70d89e114@gmail.com>
In-Reply-To: <20261105-ath-recovery-scan-timeout-v1-0-99a70d89e114@gmail.com>
To: Jeff Johnson <jjohnson@kernel.org>, Kalle Valo <kvalo@kernel.org>, 
 Hari Chandrakanthan <quic_haric@quicinc.com>, 
 Venkateswara Naralasetty <quic_vnaralas@quicinc.com>, 
 Pradeep Kumar Chitrapu <quic_pradeepc@quicinc.com>, 
 Anilkumar Kolli <quic_akolli@quicinc.com>, 
 Loic Poulain <loic.poulain@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org, 
 linux-kernel@vger.kernel.org, 
 Maharaja Kennadyrajan <quic_mkenna@quicinc.com>, 
 John Crispin <john@phrozen.org>, 
 Govindaraj Saminathan <quic_gsamin@quicinc.com>, ath10k@lists.infradead.org, 
 Wen Gong <quic_wgong@quicinc.com>, 
 Christopher Griffin <christophergriffin05@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793902298; l=1474;
 i=christophergriffin05@gmail.com; s=20261024; h=from:subject:message-id;
 bh=8zbD+lVnCTk/jEl5MxoVBJ8ccaebPXe50Jkz06PSJ0A=;
 b=93y/2nl2YnFu6ut5Bipi9DZVLRdNz+4uwAG5tLNRkc+9yVtXFwKW2evOomIGBWZaD28W8JsoP
 soM4m5afM/6A/qZsSUC5/VBfZMLOzbkzBho8GVpxty70WnYk0VTebWq
X-Developer-Key: i=christophergriffin05@gmail.com; a=ed25519;
 pk=oa9tkTNpiGoFWdGvpDHXLSobApmsh9BfrJRJrRJAvWA=
X-Endpoint-Received: by B4 Relay for
 christophergriffin05@gmail.com/20261024 with auth_id=1309
X-Original-From: Christopher Griffin <christophergriffin05@gmail.com>
Reply-To: christophergriffin05@gmail.com
Content-Transfer-Encoding: 7bit

From: Christopher Griffin <christophergriffin05@gmail.com>

When ath10k_start_scan() fails, ath10k_hw_scan() sets the scan state
back to idle and returns the error to mac80211, but first still queues
ar->scan.timeout. The timeout then stays pending for the full scan time
(20 s by default) although no scan is running. A scan started within
that time gets no timeout of its own, as the work is already pending,
and the stale one aborts it early.

Don't queue the timeout when the scan did not start, as
ath10k_remain_on_channel() already does. Until commit 634349bae0b2
("ath10k: move hw_scan worker queuing") ath10k_start_scan() queued it,
on success only.

ath11k has the same code; there, a QCN9074 firmware crash during a scan
left such a timeout pending.

Fixes: 634349bae0b2 ("ath10k: move hw_scan worker queuing")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Christopher Griffin <christophergriffin05@gmail.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 8e604697d6c20..2fded15b61721 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -6491,6 +6491,7 @@ static int ath10k_hw_scan(struct ieee80211_hw *hw,
 		spin_lock_bh(&ar->data_lock);
 		ar->scan.state = ATH10K_SCAN_IDLE;
 		spin_unlock_bh(&ar->data_lock);
+		goto exit;
 	}
 
 	ieee80211_queue_delayed_work(ar->hw, &ar->scan.timeout,

-- 
2.43.0


