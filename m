Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.184]:33514 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbZAWTGY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 14:06:24 -0500
Received: by fk-out-0910.google.com with SMTP id f33so1370532fkf.5
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2009 11:06:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <e27b78a40901230803t8eafb3cx6d70ceaec68daf09@mail.gmail.com>
References: <e27b78a40901230803t8eafb3cx6d70ceaec68daf09@mail.gmail.com>
Date: Fri, 23 Jan 2009 11:06:22 -0800
Message-ID: <45e8e6c40901231106t481c823ag3bbac67d8205ef7a@mail.gmail.com> (sfid-20090123_200628_735488_1DC7A071)
Subject: Re: Crashing on ping?
From: Andrey Yurovsky <andrey@cozybit.com>
To: Keir <keirlawson@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Keir.  Incidentally, we're using ath5k mesh right now at commit
93bd2ac7301b0879821e584991f82de372d62bf6 (that's just after the
2.6.29-rc1 tag but before -rc2) an things work fine.  I haven't had a
chance to try head of wireless-testing this week.

  -Andrey

On Fri, Jan 23, 2009 at 8:03 AM, Keir <keirlawson@gmail.com> wrote:
> I just pulled the latest wireless-testing kernel, however, much like
> the previous wireless-testing kernel I was working on, when attempting
> to ping one node from another on a mesh, using ath5k, the node
> attempting to ping completely freezes after about 7 pings are
> (succesfully) sent.  Anyone have any idea what is going wrong here?
>
> Cheers
>
> Keir
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
