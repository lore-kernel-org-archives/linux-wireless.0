Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbcDUJSY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2016 05:18:24 -0400
Date: Thu, 21 Apr 2016 11:16:39 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, helmut.schaa@googlemail.com,
	kvalo@qca.qualcomm.com
Subject: Re: [PATCH v2] rt2800lib: enable MFP if hw crypt is disabled
Message-ID: <20160421091639.GA9797@redhat.com> (sfid-20160421_112647_072216_F87BE384)
References: <1461170494-576-1-git-send-email-yeohchunyeow@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1461170494-576-1-git-send-email-yeohchunyeow@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 21, 2016 at 12:41:34AM +0800, Chun-Yeow Yeoh wrote:
> If rt2800usb is loaded with nohwcrypt=1, mac80211 takes
> care of the crypto with software encryption/decryption
> and thus, MFP can be used.
> 
> Tested for secured mesh using ath9k_htc and ath9k.
> 
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>

Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
