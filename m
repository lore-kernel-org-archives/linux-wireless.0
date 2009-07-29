Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:49027 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165AbZG2Vxb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 17:53:31 -0400
Received: by gxk9 with SMTP id 9so1972149gxk.13
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2009 14:53:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090729214510.31738.90990@cl-1649.ham-01.de.sixxs.net>
References: <20090729214510.31738.90990@cl-1649.ham-01.de.sixxs.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 29 Jul 2009 14:53:11 -0700
Message-ID: <43e72e890907291453k444e2d06k864149ddcda8f351@mail.gmail.com>
Subject: Re: [Linux Wireless] Update of "en/users/Download" by ReinetteChatre
To: reinette chatre <reinette.chatre@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 29, 2009 at 2:45 PM, Linux
Wireless<johannes@sipsolutions.net> wrote:
> Dear Wiki user,
>
> You have subscribed to a wiki page or wiki category on "Linux Wireless" for change notification.
>
> The "en/users/Download" page has been changed by ReinetteChatre:
> http://wireless.kernel.org/en/users/Download?action=diff&rev1=93&rev2=94
>
>  }}}
>  '''Install''':
>
> - We use the updates/ directory so your distribution's drivers are left intact.
> + We use the updates/ directory so your distribution's drivers are left intact. By default depmod will search this directory first, but if you find that it does not then check that your depmod.conf file lists the search order correctly with ''updates'' appearing first (before ''built-in'').

Hm, so compat-wireless now actually checks this for you and if its not
there it adds it for you. Was there an issue with a particular user on
this?

  Luis
