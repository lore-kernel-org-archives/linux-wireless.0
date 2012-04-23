Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54504 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967Ab2DWWTi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 18:19:38 -0400
Message-ID: <4F95D573.4080901@hauke-m.de> (sfid-20120424_001941_541296_7FFAB565)
Date: Tue, 24 Apr 2012 00:19:31 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] compat: add module_pci_driver
References: <1335131965-20280-1-git-send-email-hauke@hauke-m.de> <CAB=NE6UbQgYY+KcUt1rD14vyfwJkX9mdbQVKzMPwtgHOC+LEQg@mail.gmail.com>
In-Reply-To: <CAB=NE6UbQgYY+KcUt1rD14vyfwJkX9mdbQVKzMPwtgHOC+LEQg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/23/2012 11:09 PM, Luis R. Rodriguez wrote:
> On Sun, Apr 22, 2012 at 2:59 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>> module_pci_driver is needed to register the pci driver to the pci sub system.
> 
> Thanks ! I see no Signed-off-by tag on these though, I use the SOB tag
> just as the kernel and other projects us it, the meaning of it is the
> same, under the "Developer's Certificate of Origin 1.1":
> 
> http://gerrit.googlecode.com/svn/documentation/2.0/user-signedoffby.html
> 
> Do you SOB these patches?
> 
>   Luis
Hi Luis,

I SOB these patches and the patches for compat-wireless I send also on
that day. I forgot to add the option to generate a SOB line in git
format-patch this time. Should I resend them with a SOB line or do you
take this late SOB in this mail?

Hauke
