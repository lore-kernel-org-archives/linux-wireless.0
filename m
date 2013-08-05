Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:50863 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445Ab3HELdk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Aug 2013 07:33:40 -0400
Received: by mail-ob0-f169.google.com with SMTP id wc20so5337029obb.14
        for <linux-wireless@vger.kernel.org>; Mon, 05 Aug 2013 04:33:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1375371582-31004-1-git-send-email-sylvain.roger.rieunier@gmail.com>
References: <1375371582-31004-1-git-send-email-sylvain.roger.rieunier@gmail.com>
Date: Mon, 5 Aug 2013 13:33:40 +0200
Message-ID: <CAGXE3d9syXY6cZjsBs0vLi72zZAeo-xM+e0Zw2jhy+ZzdjhsOA@mail.gmail.com> (sfid-20130805_133344_124137_A5ECAA8F)
Subject: Re: [[PATCHv2]rt2800usb: ampdu len] rt2800usb: update aggregation len
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Sylvain ROGER RIEUNIER <sylvain.roger.rieunier@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 1, 2013 at 5:39 PM, Sylvain ROGER RIEUNIER
<sylvain.roger.rieunier@gmail.com> wrote:
> From: Sylvain Roger Rieunier <sylvain.roger.rieunier@gmail.com>
>
> I tried to read periodically TX_AGG_CNT registers on the rt2800usb driver.
> I'had made USB synchronous and asynchronous read. But it's only reduces the
> bandwidth.
> Does anyone have an idea?
>
>
> Signed-off-by: Sylvain ROGER RIEUNIER <sylvain.roger.rieunier@gmail.com>

Instead of updating the statistics from within a timer can't you just
update them when reading the sysfs file?
Helmut
