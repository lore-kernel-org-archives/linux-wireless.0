Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:52564 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932835Ab2LHDho convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 22:37:44 -0500
Received: by mail-wg0-f46.google.com with SMTP id dr13so666562wgb.1
        for <linux-wireless@vger.kernel.org>; Fri, 07 Dec 2012 19:37:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1212080726150.22564@icf.org.ru>
References: <BD54DDEB2546894FAB0731EA7B0EDF8D07C1256F@RockMX01.rock.corp>
 <alpine.DEB.2.02.1212031842350.27546@icf.org.ru> <CAG6hwVM3GFe-v7fONDR_2wuggT+z_ZhDQN-pH7BA1gyxLZzDQQ@mail.gmail.com>
 <alpine.DEB.2.02.1212080721070.8165@icf.org.ru> <alpine.DEB.2.02.1212080726150.22564@icf.org.ru>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Fri, 7 Dec 2012 19:37:23 -0800
Message-ID: <CAG6hwVMsghDHzgyk1ZJE7YoMi2+t-LKNGtgw_ha2DdEwHc71hg@mail.gmail.com> (sfid-20121208_043748_339418_60CEF14D)
Subject: Re: help: 802.11s bad performance with 802.11n enabled
To: Georgiewskiy Yuriy <bottleman@icf.org.ru>
Cc: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	open11s <devel@lists.open80211s.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 7, 2012 at 7:29 PM, Georgiewskiy Yuriy <bottleman@icf.org.ru> wrote:
> On 2012-12-08 07:23 +0400, Georgiewskiy Yuriy wrote Thomas Pedersen:
>
> GY>On 2012-12-07 19:17 -0800, Thomas Pedersen wrote Georgiewskiy Yuriy:
> GY>
> GY>ок, i try this and report results, can you also test on 2.4 Ggz? as i
> GY>understand ch 149 is 802.11a? or this make no sense here?
>
> and also signal level make sense in my case, i just remove antennas from one of the nodes
> in range of 3 meters, it works only with pigtails, signal drops to -70 - -80 dbm, and it's
> triggers filed to stop tx dma immediatlly.

Are you talking about a different bug?

Thomas
