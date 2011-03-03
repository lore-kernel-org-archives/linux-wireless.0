Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55180 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758175Ab1CCO1c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 09:27:32 -0500
Received: by iyb26 with SMTP id 26so958864iyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2011 06:27:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTinoAB57TtenYTvK3cR96nBh+Aq83DdxACoAiaS5@mail.gmail.com>
References: <AANLkTimH6qYcUsE6tyQK31-8iHjRaR_sLZcYcerDtuiU@mail.gmail.com>
	<AANLkTikHz40gB8KXEjy+6=WFbdAbxOTwtXam_zF0_Dex@mail.gmail.com>
	<AANLkTinoAB57TtenYTvK3cR96nBh+Aq83DdxACoAiaS5@mail.gmail.com>
Date: Thu, 3 Mar 2011 14:27:32 +0000
Message-ID: <AANLkTin=NKniH_rnxMw=C2oy-pSw_mwEpqNRYwmd7-3-@mail.gmail.com>
Subject: Sniffer 802.11 L2 Management Frames
From: =?ISO-8859-1?Q?Carlos_Guimar=E3es?= <asc2.cemg@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm working on a project for sniffer 802.11 L2 Management Frames. I can only
sniffer those packets when I set my NIC mode in Monitor Mode, however I
need to capture those packets and still be connect with some AP, i.e., I
need that my NIC mode in Managed Mode and still capture 802.11 L2
Management Frames. There is some way to do that (something like register
in kernel the packets I want to receive in userspace)?

Thanks,
Carlos Guimarães
