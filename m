Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:63055 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760AbZJNGYE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2009 02:24:04 -0400
Received: by ey-out-2122.google.com with SMTP id 9so143879eyd.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2009 23:22:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890910131751k11f0d05ehea98c32d6195d4be@mail.gmail.com>
References: <1255479847.6242.0.camel@shadow>
	 <43e72e890910131751k11f0d05ehea98c32d6195d4be@mail.gmail.com>
Date: Wed, 14 Oct 2009 08:22:57 +0200
Message-ID: <2d0a357f0910132322l1ed6ccdak608d2b329389cc57@mail.gmail.com>
Subject: Re: compat-wireless 2.6.32-rc4 failed to compile
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: aherrerag@uci.cu, linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The Linus-tree has not all patches from wireless-testing GIT master,
only the ones from John's pull-requests.
IIRC compat-wireless (bleeding edge) has the w-t ones included.
c-w (stable-2.6.32-rc4) don't know...

- Sedat -

On Wed, Oct 14, 2009 at 2:51 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Tue, Oct 13, 2009 at 5:24 PM, Anielkis Herrera Gonzalez
> <aherrerag@uci.cu> wrote:
>> # uname -r
>> 2.6.32-rc4
>
> Remind me why you are trying to compile
> compat-wireless-stable-2.6.32-rc4 if you already are running
> 2.6.32-rc4?
>
>  Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
