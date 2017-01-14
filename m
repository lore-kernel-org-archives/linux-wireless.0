Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35078 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751389AbdANQsc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 14 Jan 2017 11:48:32 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Daniel Golle <daniel@makrotopia.org>,
        linux-wireless@vger.kernel.org, lede-dev@lists.infradead.org,
        openwrt-devel@lists.openwrt.org, john@phrozen.org, nbd@nbd.name,
        roman@advem.lv, evaxige@qq.com, c.mignanti@gmail.com,
        michel.stempin@wanadoo.fr, vasilugin@yandex.ru,
        Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: [RFC] [PULL REQUEST] rt2x00 patches from OpenWrt.org
References: <20170113035020.GA9063@makrotopia.org>
        <20170113141554.GA8018@redhat.com>
Date: Sat, 14 Jan 2017 18:48:25 +0200
In-Reply-To: <20170113141554.GA8018@redhat.com> (Stanislaw Gruszka's message
        of "Fri, 13 Jan 2017 15:15:55 +0100")
Message-ID: <87eg05io4m.fsf@purkki.adurom.net> (sfid-20170114_174855_217121_B1AC57A2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> writes:

> Hi
>
> On Fri, Jan 13, 2017 at 04:50:32AM +0100, Daniel Golle wrote:
>> Please review and comment, so we can get those patches merged!
>
> As already pointed by Kalle posting patches to mailing list is better
> way for review. Posing patches is easy with git-format-patch and
> git-send-email. Ideally patch series should not be long, let say no more
> than 30 patches - I suggest to split this into two series: second one
> for RT3853 support and first one for other patches.

Even 30 patches in a set is quite a lot. I think the pain point is
somewhere about 10-12 patches, anything longer than that and most people
lost interest looking at the patches in detail.

-- 
Kalle Valo
