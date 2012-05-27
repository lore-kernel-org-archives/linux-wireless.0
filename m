Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44231 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002Ab2E0LaN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 May 2012 07:30:13 -0400
Message-ID: <4FC2103B.3040104@openwrt.org> (sfid-20120527_133052_040477_45CE34E5)
Date: Sun, 27 May 2012 13:30:03 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
CC: Adrian Chadd <adrian@freebsd.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] Anyone doing WiFi throughput tests?
References: <4FC04B5A.1070900@candelatech.com> <CAJ-VmomRv-GdRooL=1G5avxAqJ4h3eoAfNkzYit3ok-fXmd25A@mail.gmail.com> <20417.35821.91808.2702@gargle.gargle.HOWL> <20417.36056.95300.690329@gargle.gargle.HOWL>
In-Reply-To: <20417.36056.95300.690329@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-05-27 4:09 AM, Sujith Manoharan wrote:
> Sujith Manoharan wrote:
>> Odd. I get low numbers with a DB120 running OpenWRT (git HEAD).
>> 
>> TCP TX - ~260 Mbps.
>> TCP RX - ~160 Mbps.
>> 
>> UDP RX - ~240 Mbps.
>> UDP TX - iperf borks and doesn't display anything.
>> 
>> The load seems to be a bit high (average: 1.92, 1.06, 0.61 ) and the
>> console becomes laggy.
>> 
>> Maybe 
> 
> Huh.
> 
> Now that I have added "(setq vm-confirm-mail-send t)" to my .emacs, I'll
> finish the email. :)
> 
> Maybe support for DB120 is not complete yet - but am not sure.
I will look into it.

- Felix
