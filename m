Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:55463 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474AbZJGFlB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2009 01:41:01 -0400
Received: by iwn8 with SMTP id 8so2683907iwn.33
        for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2009 22:40:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1254886762-17211-1-git-send-email-HinTak.Leung@gmail.com>
References: <1254886762-17211-1-git-send-email-HinTak.Leung@gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 7 Oct 2009 01:40:04 -0400
Message-ID: <43e72e890910062240w7b4f0895t7f009b99da8fac40@mail.gmail.com>
Subject: Re: [PATCH] compat-2.6: adding ethtool.h to compat-2.6.31.h
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Hin-Tak Leung <htl10@users.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 6, 2009 at 11:39 PM, Hin-Tak Leung <hintak.leung@gmail.com> wrote:
> Between 2.6.30 and 2.6.31, linux/netdevice.h started
> to include linux/ethtool.h (commit b1b67dd45a6b629eb41553856805aaa1614fbb83,
> "net: factor out ethtool invocation of vlan/macvlan drivers"),
> and commit 7508e486965b0af13984bc6d9da62a8d8f0dc5f9,
> "cfg80211: add firmware and hardware version to wiphy", introduces
> dependency of ETHTOOL_BUSINFO_LEN from linux/ethtool.h
> to net/cfg80211.h .

John's patch titled "cfg80211: fix compile error from missing
ethtool.h" seems to address this upstream. I'll wait until he applies
that to the tree.

  Luis
