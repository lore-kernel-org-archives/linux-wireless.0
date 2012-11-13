Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:54033 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488Ab2KMRvq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 12:51:46 -0500
Received: by mail-ie0-f174.google.com with SMTP id k13so11119181iea.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Nov 2012 09:51:46 -0800 (PST)
Message-ID: <50A288AD.2060704@lwfinger.net> (sfid-20121113_185150_243898_407A5B38)
Date: Tue, 13 Nov 2012 11:51:41 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Maxim Mikityanskiy <maxtram95@gmail.com>
CC: Greg Kroah-Hartman <greg@kroah.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/17] RTL8187SE driver cleanups
References: <1352757511-26957-1-git-send-email-maxtram95@gmail.com> <50A17A2B.6060301@lwfinger.net> <CAKErNvpCD+HXy10PRJ6CEfZpw6Z8n6yBPwjdYjDv4QW1zUX_xg@mail.gmail.com>
In-Reply-To: <CAKErNvpCD+HXy10PRJ6CEfZpw6Z8n6yBPwjdYjDv4QW1zUX_xg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/13/2012 11:18 AM, Maxim Mikityanskiy wrote:
>
> I'm sorry, I'll remake patches with correct base and resend them.
> Really, you could use "cd drivers/staging/rtl8187se" instead of sed,
> it might be easier for you.

Actually, that would be more trouble as I always use quilt to handle patches 
like this, and having the patches directory in more than one place would be a 
hassle.

Larry


