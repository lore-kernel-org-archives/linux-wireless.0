Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46669 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932522Ab1JDQmT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 12:42:19 -0400
Received: by eya28 with SMTP id 28so670028eya.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Oct 2011 09:42:18 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Adrian Chadd <adrian@freebsd.org>
Subject: Re: [RFC 5/6] ath9k: enable DFS pulse detection
Date: Tue, 4 Oct 2011 18:42:04 +0200
Cc: Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	kgiori@qca.qualcomm.com, nbd@openwrt.org
References: <1317637758-11907-1-git-send-email-zefir.kurtisi@neratec.com> <201110041726.40722.chunkeey@googlemail.com> <CAJ-Vmom44ZDo7CqrnNgo+MQ=otOB=+WyQYAyAZAt2ko=STkSsA@mail.gmail.com>
In-Reply-To: <CAJ-Vmom44ZDo7CqrnNgo+MQ=otOB=+WyQYAyAZAt2ko=STkSsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201110041842.05218.chunkeey@googlemail.com> (sfid-20111004_184224_429713_32F36C7E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, October 04, 2011 05:57:32 PM Adrian Chadd wrote:
> On 4 October 2011 23:26, Christian Lamparter <chunkeey@googlemail.com> wrote:
> > On Tuesday, October 04, 2011 04:50:42 PM Adrian Chadd wrote:
> >> Also whilst I'm at it, "SPECTRUM_MANAGEMENT" is a very broad flag to set.
> >
> > Hm, 802.11-2007 5.4.4 "Spectrum management services" explicitly
> > mentions that both services TPC and DFS are required in some
> > regulatory domains for operation in the 5 GHz band.
> 
> Right, but just for hostap mode, correct? I'm also thinking about
> non-hostap mode support.
I don't think it's just hostap mode. More like hostap, IBSS and MESH.
In fact, with P2P/Wifi-Direct, the station mode might becoming a
thing of the past, right?

> > [ Just for fun: Do you know how the AR5418 handled radars in
> > the proprietary turbo mode in the 5 GHz band? And how does
> > Atheros own driver/stack/etc. deals with this limitation?
> > After all Unex sold/sells the DNBA-81 on their product page
> > as: <http://www.unex.com.tw/product/dnba-81>
> >
> > "DNBA-81 is a 802.11n 2x3 2-stream a/b/g dual band wifi
> > Cardbus designed specifically for laptops and *access points*/
> > home gateways/consumer electronics/multimedia entertainment
> > devices/peripherals with standard Cardbus slot." ]
> 
> Besides, you realise that vendors say the darnest things at times? :)
> For example, one well-known vendor lists their AR9160 NICs as DFS
> ready (and thus people who buy them think they're DFS ready), but if
> you buy some of their MIPS SOC hardware, they only support
> OpenWRT+ath9k on it. I'm sure more than a few people fell into that
> trap. :)
Well, ok. I found a better example:
http://www.wikidevi.com/wiki/Apple_AirPort_Extreme_Base_Station_A1143_%28MA073LL/A%29

You see, they put an AR5418(or 6?) with an AR5133 into the first draft-n
Apple Airport Base Station. If this much money was involved, do you
think that an American Company would "lie" to another American Company?

Regards,
	Chr
