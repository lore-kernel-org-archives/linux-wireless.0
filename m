Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:35699 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab3EUIQI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 May 2013 04:16:08 -0400
Received: by mail-ie0-f173.google.com with SMTP id k5so698060iea.18
        for <linux-wireless@vger.kernel.org>; Tue, 21 May 2013 01:16:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMfPB_xTUy72YokSoYJezOX_gb54CJEd7V6+4pAfOHnAzUMJcQ@mail.gmail.com>
References: <CAMfPB_xTUy72YokSoYJezOX_gb54CJEd7V6+4pAfOHnAzUMJcQ@mail.gmail.com>
Date: Tue, 21 May 2013 10:16:07 +0200
Message-ID: <CAGXE3d8u4ORgmOAdKFbgYSA3qTQxfhKiT6feDMMwn_-ue0ehow@mail.gmail.com> (sfid-20130521_101613_726843_E6455434)
Subject: Re: rt3070-based usb device won't accept mac address changes
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Alessandro Lannocca <alessandro.lannocca@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 18, 2013 at 5:10 PM, Alessandro Lannocca
<alessandro.lannocca@gmail.com> wrote:
> Hi, after switching to kernel 3.8.8 (ubuntu quantal to raring), I'm
> unable to change my alfa AWUS036NH mac address; a simple:
>
> ifconfig <device> down
> ifconfig <device> hw ether <random hw>
>
> results in:
>
> SIOCSIFHWADDR: Invalid argument

Do you have multiple wifi interfaces or just that single one?
Helmut
