Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:48493 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761798AbYA1VRy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2008 16:17:54 -0500
Date: Mon, 28 Jan 2008 22:15:29 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "Lars Ericsson" <Lars_Ericsson@telia.com>
Cc: "'John W. Linville'" <linville@tuxdriver.com>,
	"'Larry Finger'" <larry.finger@lwfinger.net>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [RFT] [PATCH] rc80211-pid: fix rate adjusting
Message-ID: <20080128221529.1e46c4f6@morte> (sfid-20080128_211824_781961_D9B25687)
In-Reply-To: <00db01c861e4$abc2fea0$0b3ca8c0@gotws1589>
References: <20080127204606.63fbbaf7@morte>
	<00db01c861e4$abc2fea0$0b3ca8c0@gotws1589>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 28 Jan 2008 20:33:33 +0100
"Lars Ericsson" <Lars_Ericsson@telia.com> wrote:

> Hi,
> 
> Sorry, it took me some time to start testing.
> I was using a rt2x00 kernel, which did not compile the patch.
> Am using a RT61 minPCI as the STA.
> 
> Have build a new wireless kernel and made some initial test.
> 
> Findings so far:
> 1) It does not select 11g speeds on 11b AP, fine.
> 2) It does not use 11g speeds on 11g AP, not so good.

What happens if you force an 802.11g rate?


--
Ciao
Stefano
