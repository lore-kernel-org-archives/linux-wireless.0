Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:33194 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932703AbcCROdg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2016 10:33:36 -0400
Received: by mail-ob0-f171.google.com with SMTP id fz5so118474340obc.0
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2016 07:33:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56EC057A.9000804@users.sourceforge.net>
References: <cover.1458262312.git.julian.calaby@gmail.com> <01ae52425e9dba9f82f8d107da02a0d2cd23f09d.1458262312.git.julian.calaby@gmail.com>
 <56EC057A.9000804@users.sourceforge.net>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Sat, 19 Mar 2016 01:33:16 +1100
Message-ID: <CAGRGNgUY+fr2vaJ=uUhqzGRMCLmyKn+2QTJGD8copXgCYv8YPA@mail.gmail.com> (sfid-20160318_153341_557249_0CFF79AC)
Subject: Re: [PATCH 08/19] iwlegacy: Return directly if allocation fails in il_eeprom_init()
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Jia-Ju Bai <baijiaju1990@163.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Markus,

On Sat, Mar 19, 2016 at 12:41 AM, SF Markus Elfring
<elfring@users.sourceforge.net> wrote:
>> Also remove an unused label.
>
> Is such a commit message a bit too short?

I don't think so, but I don't decide these sorts of things.

Does anyone else have an opinion on this?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
