Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:24577 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758048AbYAHPiH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2008 10:38:07 -0500
Received: by py-out-1112.google.com with SMTP id u52so13265890pyb.10
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jan 2008 07:38:07 -0800 (PST)
Message-ID: <43e72e890801080738k199e5d99n2faf0640b380c071@mail.gmail.com> (sfid-20080108_153818_841232_FC77A250)
Date: Tue, 8 Jan 2008 10:38:06 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Ralph Spitzner" <rasp@spitzner.org>
Subject: Re: ath5k
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
In-Reply-To: <478346AD.4050601@spitzner.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <478346AD.4050601@spitzner.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 8, 2008 4:47 AM, Ralph Spitzner <rasp@spitzner.org> wrote:
> Sorry about my last post, but I found the pointer to the patch
> a little late....
>
> But, :-) while browsing through the source I still cannot locate
> where the problem for ath5k master mode lies.
> Any pointers (hw.c [?]).

ath5k's base.[ch] files need implementation and integration with
mac80211 for AP mode support. mac80211 itself is still being worked on
for AP mode. On the bright side ath5k's hw.c should already have AP
mode routines, you just really need to make the proper hooks into
mac80211. Johannes has been working on AP mode, I can recommend to
review his patches if you're interested in adding AP mode. Also feel
free to check out the old madwifi-old-openhal which supposedly had AP
mode support with net80211.

  Luis
