Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:57324 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756194AbZBDXtS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 18:49:18 -0500
Received: by fg-out-1718.google.com with SMTP id 16so1389841fgg.17
        for <linux-wireless@vger.kernel.org>; Wed, 04 Feb 2009 15:49:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1233790843-7000-1-git-send-email-HinTak.Leung@gmail.com>
References: <1233790843-7000-1-git-send-email-HinTak.Leung@gmail.com>
Date: Wed, 4 Feb 2009 23:49:16 +0000
Message-ID: <3ace41890902041549g121c2422m3bcc17d82d7d9b65@mail.gmail.com> (sfid-20090205_004932_610569_CA53CD14)
Subject: Re: [PATCH] zd1211rw: treat MAXIM_NEW_RF(0x08) as UW2453_RF(0x09) for
	TP-Link WN322/422G
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 4, 2009 at 11:40 PM, Hin-Tak Leung <hintak.leung@gmail.com> wrote:
> Three people (Petr Mensik <pihhan@cipis.net>
> ["si" should be U+0161 U+00ED], Stephen Ho <stephenhoinhk@gmail.com>
> on zd1211-devs and Ismael Ojeda Perez <iojedaperez@gmail.com>
> on linux-wiress) reported success in getting TP-Link WN322G/WN422G

Damn, typo... "linux-wireless" . please fix the commit message when
you get this in?
