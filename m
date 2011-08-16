Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55094 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab1HPWIl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Aug 2011 18:08:41 -0400
Received: by yxj19 with SMTP id 19so305129yxj.19
        for <linux-wireless@vger.kernel.org>; Tue, 16 Aug 2011 15:08:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E4ACD10.7000807@01019freenet.de>
References: <4E4AB695.5070300@01019freenet.de>
	<CAOZOX0UsRxT9ECdUC7OL2toJUb+PitGhxCifTyD8hWYwt6R_zg@mail.gmail.com>
	<4E4ACD10.7000807@01019freenet.de>
Date: Wed, 17 Aug 2011 00:08:40 +0200
Message-ID: <CAGXE3d-hb2MnLW+NhxCBhUSGTNSs5ki9-6wo5uQGSJbFdEB5KA@mail.gmail.com> (sfid-20110817_000849_490408_36397E87)
Subject: Re: 7 more packets after each beacon frame
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: Ivo Van Doorn <ivdoorn@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 16, 2011 at 10:03 PM, Andreas Hartmann
<andihartmann@01019freenet.de> wrote:
>> When examining my own AP (rt2860 based) with another STA in monitor
>> mode, I can see always 7 packets after each beacon frame:

That looks quite odd. Maybe some garbage ended up in the beacon slots
after the first beacon.
Do you use multiple virtual interfaces?

Helmut
