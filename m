Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52442 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955Ab0GUT7F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jul 2010 15:59:05 -0400
Received: by fxm14 with SMTP id 14so3870713fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Jul 2010 12:59:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1279583798.28066.3.camel@wwguy-ubuntu>
References: <1279565034.4572.36.camel@localhost.localdomain>
	<AANLkTinGUQjPoMRmt_jeFgpxLhzma7qhfR14t_tWLvO1@mail.gmail.com>
	<1279582174.4572.43.camel@localhost.localdomain>
	<1279583798.28066.3.camel@wwguy-ubuntu>
Date: Wed, 21 Jul 2010 21:59:02 +0200
Message-ID: <AANLkTinJrjvSUuOSeb6fQESN-T789wWCU1ezRXwQ3KXK@mail.gmail.com>
Subject: Re: iwlagn and many firmware restarts with Fedora kernel
From: drago01 <drago01@gmail.com>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 20, 2010 at 1:56 AM, Guy, Wey-Yi <wey-yi.w.guy@intel.com> wrote:
> Hi drago,
>
>
> Are you using 5350? here I attach a "RFC patch", could you give a try to
> see if it help?

Not quite I am on 5300; your patch seem to only touch the 5350 code
... should I try the same change for 5300?
