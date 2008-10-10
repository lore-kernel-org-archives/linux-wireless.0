Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:10469 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764628AbYJJVil (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 17:38:41 -0400
Received: by nf-out-0910.google.com with SMTP id d3so363256nfc.21
        for <linux-wireless@vger.kernel.org>; Fri, 10 Oct 2008 14:38:39 -0700 (PDT)
Message-ID: <48EFCB5C.6090303@gmail.com> (sfid-20081010_233917_192758_364D2116)
Date: Fri, 10 Oct 2008 22:38:36 +0100
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@mail.ru>
CC: orinoco-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] orinoco: fix unsafe locking in orinoco_cs_resume
References: <200810102022.40027.arvidjaar@mail.ru>
In-Reply-To: <200810102022.40027.arvidjaar@mail.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrey Borzenkov wrote:
> Attached patch should fixe lockdep warning. Unfortunately it is rather
> hard to trigger on purpose.

ACK.

Looks like spectrum_cs has the same problem with suspend. I'll submit a patch for that.



Dave.
