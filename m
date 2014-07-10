Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:58632 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025AbaGJVX0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 17:23:26 -0400
Received: by mail-oa0-f43.google.com with SMTP id o6so220003oag.2
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2014 14:23:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1404320863-13372-1-git-send-email-zajec5@gmail.com>
References: <1404320863-13372-1-git-send-email-zajec5@gmail.com>
Date: Thu, 10 Jul 2014 23:23:25 +0200
Message-ID: <CACna6rw+h_DtxxsvEp1Obp2B8zmnquvDXeoOmqMY-kPUpwXZ4w@mail.gmail.com> (sfid-20140710_232332_496052_EEEAE66F)
Subject: Re: [PATCH] b43: always print info about radio (manuf, id, revision)
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev <b43-dev@lists.infradead.org>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2 July 2014 19:07, Rafał Miłecki <zajec5@gmail.com> wrote:
> Type of radio has a major meaning for the driver. There is quite some
> code that does initialization/calibration depending on the radio rev.
> Knowing radio params is quite important to provide help to users, so
> print it even with debugging disabled.
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> This increases amount of lines that are always printed by b43 from 3 to
> 4. Do you think it's still acceptable? I'd really like to know what
> radio are using ppl reporting any problems.

John: since there weren't any objections for a week, please take this patch.
