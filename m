Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56913 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141Ab1HPSo4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Aug 2011 14:44:56 -0400
Received: by ywf7 with SMTP id 7so163818ywf.19
        for <linux-wireless@vger.kernel.org>; Tue, 16 Aug 2011 11:44:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E4AB695.5070300@01019freenet.de>
References: <4E4AB695.5070300@01019freenet.de>
Date: Tue, 16 Aug 2011 20:44:55 +0200
Message-ID: <CAOZOX0UsRxT9ECdUC7OL2toJUb+PitGhxCifTyD8hWYwt6R_zg@mail.gmail.com> (sfid-20110816_204459_639519_F3A58EC1)
Subject: Re: 7 more packets after each beacon frame
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> When examining my own AP (rt2860 based) with another STA in monitor
> mode, I can see always 7 packets after each beacon frame:

Well if it is an AP with a rt2860 chipset, then it probably isn't
using the rt2x00 drivers,
so no idea what those extra frames would be.
Can't they come from another client somewhere which is responding to the AP?

Ivo
