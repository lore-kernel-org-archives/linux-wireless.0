Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:60735 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab2DRPhb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 11:37:31 -0400
Date: Wed, 18 Apr 2012 16:37:28 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>
Subject: Re: brcmsmac hangs machine if loaded after busmastering disabled
Message-ID: <20120418153728.GA32224@srcf.ucam.org> (sfid-20120418_173734_424778_992029FC)
References: <20120319215154.GA18508@srcf.ucam.org>
 <4F856EE9.2040407@broadcom.com>
 <20120411115118.GA3791@srcf.ucam.org>
 <4F8EA657.7020006@broadcom.com>
 <20120418123449.GB26953@srcf.ucam.org>
 <4F8EDDE6.9080802@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4F8EDDE6.9080802@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 18, 2012 at 05:29:42PM +0200, Arend van Spriel wrote:

> I am not sure, but D3 is a good guess. It is all a workaround as the
> real fix should be in Apple's UEFI implementation. I think it is
> unlikely we can make them do that although we probably supplied them
> the wireless part.

Disabling busmastering and then D3ing the device once in the kernel 
didn't seem to work, but putting the device in D3 while in the firmware 
(and leaving busmastering enabled) seems to avoid the problem.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
