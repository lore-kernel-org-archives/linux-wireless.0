Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:33380 "EHLO
	mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbcA2C0G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 21:26:06 -0500
Received: by mail-lf0-f53.google.com with SMTP id s81so38737397lfd.0
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jan 2016 18:26:05 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 29 Jan 2016 10:26:04 +0800
Message-ID: <CALUcjaOWy=T+Xw7hvi05LHRa8N2zvEvhB=TjOhan-xdirMBXxA@mail.gmail.com> (sfid-20160129_032616_135526_DF14F26D)
Subject: how to kick off wifi user
From: Joe Qiao <qlnaaa@gmail.com>
To: Linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,

Now I setup AP and want to find a way to kick off a special wifi user
from the AP. I know “iw dev station del”, but it seems it only remove
the station data from driver inside, but cannot trigger a
disassociation frame wireless client. Would you please give some
guidance about kick off wifi user?

Appreciate if any help!

-Joe
