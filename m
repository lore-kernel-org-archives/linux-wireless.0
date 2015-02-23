Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:65508 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbbBWOPf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2015 09:15:35 -0500
Received: by mail-ob0-f169.google.com with SMTP id wp4so36661343obc.0
        for <linux-wireless@vger.kernel.org>; Mon, 23 Feb 2015 06:15:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAMArcTVU0KawzTCtX-QK2=z-tw=Te_jLpWErdOkQ4eg89WM5ig@mail.gmail.com>
References: <1424443813-13634-1-git-send-email-ap420073@gmail.com>
	<loom.20150220T175341-637@post.gmane.org>
	<CAMArcTXL7Ydka54p6HvRvP=LvFo+w56YnMMrSuUo+PnAsy1TbQ@mail.gmail.com>
	<CALA4C6UWNY3cMe6BskMNOOK4BZV40hNpnpocTKkRNSvOqHbfOA@mail.gmail.com>
	<CAMArcTVU0KawzTCtX-QK2=z-tw=Te_jLpWErdOkQ4eg89WM5ig@mail.gmail.com>
Date: Mon, 23 Feb 2015 14:15:35 +0000
Message-ID: <CALA4C6U6bw9ENwujCHfCy-LFjr=tEyCd_-SdBE_fLAakrRd2Xg@mail.gmail.com> (sfid-20150223_151547_140809_EDD53C60)
Subject: Re: [PATCH] rtlwifi: rtl8192cu: Fix some beacon issue
From: Mike Turner <miketurner.forum@gmail.com>
To: "ap420073 ." <ap420073@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 20, 2015 at 6:47 PM, ap420073 . <ap420073@gmail.com> wrote:
> hostapd 2.3 has no problem but i found problem that hostapd is not
> starting in hostapd 1.0.
>
> would you like to try testing hostapd 2.3?
>

Unfortunately v2.3 has the some problem. After a few cycles of
/etc/init.d/hostapd stop and start it sometimes stops sending the
beacon. Further cycles may or may not start sending beacons as per my
original posts.
