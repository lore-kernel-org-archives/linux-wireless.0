Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.230]:61124 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167AbYLLWyD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 17:54:03 -0500
Received: by rv-out-0506.google.com with SMTP id k40so1585499rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 12 Dec 2008 14:54:03 -0800 (PST)
Message-ID: <69e28c910812121454t7d765b27l918e2f6162bd3f08@mail.gmail.com> (sfid-20081212_235408_633296_F7DF473B)
Date: Fri, 12 Dec 2008 23:54:03 +0100
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC 0/3] cfg80211, mac80211: Introduce radiotap flags for finer userspace control of injection
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1229122225.3565.16.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <69e28c910812121432k1e8732bcma77e489d247ecdf4@mail.gmail.com>
	 <1229121467.3565.2.camel@johannes.berg>
	 <69e28c910812121440j6e010ac0j6e08cd6a53f58bcb@mail.gmail.com>
	 <1229122225.3565.16.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 12, 2008 at 11:50 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2008-12-12 at 23:40 +0100, Stefanik G=E1bor wrote:
>
>> [...]
>
> Incidentally, as for the radiotap changes, I'm wondering whether the
> flag really should be "no seqno" or should be "assign seqno" instead.=
 It
> seems injection should be "as raw as possible" by default. But things
> like that really need to be worked out with people from other systems=
=2E
>
> johannes
>

Using an "assign seqno" flag would cause existing injectors that
expect the kernel to do seq numbering for them to fail. This possibly
includes hostap and penumbra.

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
