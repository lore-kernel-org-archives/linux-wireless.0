Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:38448 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933538Ab3B0A11 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2013 19:27:27 -0500
MIME-Version: 1.0
In-Reply-To: <CAB=NE6VkOHe17=uRJ537r7nF_0aQQNCeto8CnMON6EpqP0qbbA@mail.gmail.com>
References: <1361648055-15871-1-git-send-email-kazikcz@gmail.com>
 <CAB=NE6WAKjktv8G1eikkfkbB7KAa_XefJj-udfH8b_vvgLbznQ@mail.gmail.com>
 <CABvG-CW+ykoZMz49UNS11=rLViNQ3uyo-sHeJqOdp06Vwd628g@mail.gmail.com> <CAB=NE6VkOHe17=uRJ537r7nF_0aQQNCeto8CnMON6EpqP0qbbA@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Tue, 26 Feb 2013 16:27:05 -0800
Message-ID: <CAB=NE6XWhzncFg=YjdKApkP-eApJv8AozgS=kYzqZtC553haKA@mail.gmail.com> (sfid-20130227_012746_170890_63606145)
Subject: Re: [PATCH] ath: sanitize 0xFFFF regdomain
To: =?UTF-8?Q?Micha=C5=82_Kazior?= <kazikcz@gmail.com>
Cc: David Quan <dquan@qca.qualcomm.com>, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, Pavel Roskin <proski@gnu.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 26, 2013 at 12:01 PM, Luis R. Rodriguez
<mcgrof@qca.qualcomm.com> wrote:
> Apologies again and then (unless I hear otherwise from David Quan):
>
> Acked-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>

I did hear back from David and it seems that we would never support
this. John please do not apply this just yet.

  Luis
