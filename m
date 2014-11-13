Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41178 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933342AbaKMRaC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2014 12:30:02 -0500
Message-ID: <5464EA91.60409@infradead.org> (sfid-20141113_183032_660116_0F6649A2)
Date: Thu, 13 Nov 2014 09:29:53 -0800
From: Randy Dunlap <rdunlap@infradead.org>
MIME-Version: 1.0
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linux-next@vger.kernel.org, sfr@canb.auug.org.au, mhocko@suse.cz,
	ath9k-devel@lists.ath9k.org
Subject: Re: mmotm 2014-11-12-16-34 uploaded (net/wireless/ath9k)
References: <5463fd01.PiBwUnCphi1MBsM6%akpm@linux-foundation.org>
In-Reply-To: <5463fd01.PiBwUnCphi1MBsM6%akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/12/14 16:36, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2014-11-12-16-34 has been uploaded to
> 
>    http://www.ozlabs.org/~akpm/mmotm/
> 
> mmotm-readme.txt says
> 
> README for mm-of-the-moment:
> 
> http://www.ozlabs.org/~akpm/mmotm/
> 

on x86_64: (from linux-next.patch, not mmotm patches)


  CC [M]  drivers/net/wireless/ath/ath9k/common-spectral.o
../drivers/net/wireless/ath/ath9k/common-spectral.c:40:5: error: redefinition of 'ath_cmn_process_fft'
 int ath_cmn_process_fft(struct ath_spec_scan_priv *spec_priv, struct ieee80211_hdr *hdr,
     ^
In file included from ../drivers/net/wireless/ath/ath9k/common.h:27:0,
                 from ../drivers/net/wireless/ath/ath9k/ath9k.h:27,
                 from ../drivers/net/wireless/ath/ath9k/common-spectral.c:18:
../drivers/net/wireless/ath/ath9k/common-spectral.h:146:19: note: previous definition of 'ath_cmn_process_fft' was here
 static inline int ath_cmn_process_fft(struct ath_spec_scan_priv *spec_priv,
                   ^
make[6]: *** [drivers/net/wireless/ath/ath9k/common-spectral.o] Error 1



-- 
~Randy
