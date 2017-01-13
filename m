Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42606 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751640AbdAMOVO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 09:21:14 -0500
Date: Fri, 13 Jan 2017 15:15:55 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Daniel Golle <daniel@makrotopia.org>
Cc: linux-wireless@vger.kernel.org, lede-dev@lists.infradead.org,
        openwrt-devel@lists.openwrt.org, john@phrozen.org, nbd@nbd.name,
        roman@advem.lv, evaxige@qq.com, c.mignanti@gmail.com,
        michel.stempin@wanadoo.fr, vasilugin@yandex.ru,
        Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: [RFC] [PULL REQUEST] rt2x00 patches from OpenWrt.org
Message-ID: <20170113141554.GA8018@redhat.com> (sfid-20170113_152121_654262_4C78F169)
References: <20170113035020.GA9063@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170113035020.GA9063@makrotopia.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Fri, Jan 13, 2017 at 04:50:32AM +0100, Daniel Golle wrote:
> Please review and comment, so we can get those patches merged!

As already pointed by Kalle posting patches to mailing list is better
way for review. Posing patches is easy with git-format-patch and
git-send-email. Ideally patch series should not be long, let say no more
than 30 patches - I suggest to split this into two series: second one
for RT3853 support and first one for other patches.

> evaxige (1):
>       rt2x00: fix WARN_ON_ONCE() caused by inbalanced set/clear of beacon enable bit

I think I would prefer to remove:

WARN_ON_ONCE(bcn_num != rt2x00dev->intf_beaconing);

line instead of this patch. Other patches looks ok after quick glance.
I think you can post them as normal PATCH in the topic (not as RFC).

Thanks
Stanislaw
