Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56790 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751790AbdDKN7f (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Apr 2017 09:59:35 -0400
Date: Tue, 11 Apr 2017 15:59:25 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8188eu: force driver to be built as a module
Message-ID: <20170411135925.GA4892@kroah.com> (sfid-20170411_155938_472345_664452B4)
References: <20170411091953.25069-1-hdegoede@redhat.com>
 <fb9b6ee4-ae69-282a-5c69-558b0810cf2f@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <fb9b6ee4-ae69-282a-5c69-558b0810cf2f@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 11, 2017 at 01:30:16PM +0200, Arend Van Spriel wrote:
> On 11-4-2017 11:19, Hans de Goede wrote:
> > The rtl8188eu driver defines a ton of global symbols which tend to
> > conflict with other realtek wifi drivers, force it to be built as
> > a module.
> 
> Or get rid of those globals as we did to get out of staging :-p

Give it time...
