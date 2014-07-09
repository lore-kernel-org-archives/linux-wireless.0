Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:38555 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562AbaGILAa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2014 07:00:30 -0400
MIME-Version: 1.0
In-Reply-To: <1404898305-15588-1-git-send-email-eliad@wizery.com>
References: <1404898305-15588-1-git-send-email-eliad@wizery.com>
From: Yegor Yefremov <yegorslists@googlemail.com>
Date: Wed, 9 Jul 2014 13:00:10 +0200
Message-ID: <CAGm1_kvTYiDZDuFrB9X1ZOCxrhPC_NE_UzzY8PoBpdZHrQgv_A@mail.gmail.com> (sfid-20140709_130037_150135_721BE05E)
Subject: Re: [PATCH] wlcore: add basic device-tree support
To: Eliad Peller <eliad@wizery.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	devicetree@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 9, 2014 at 11:31 AM, Eliad Peller <eliad@wizery.com> wrote:
> When running with device-tree, we no longer have a board file
> that can set up the platform data for wlcore.
> Allow this data to be passed from DT.
>
> For now, parse only the irq used. Other (optional) properties
> can be added later on.

What about adding support for "mac-address"
(Documentation/devicetree/bindings/net/ethernet.txt) node or will it
be automatically available?

Yegor
