Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45623 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017Ab2DWXGO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 19:06:14 -0400
Received: by yenl12 with SMTP id l12so37477yen.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Apr 2012 16:06:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F95D573.4080901@hauke-m.de>
References: <1335131965-20280-1-git-send-email-hauke@hauke-m.de>
 <CAB=NE6UbQgYY+KcUt1rD14vyfwJkX9mdbQVKzMPwtgHOC+LEQg@mail.gmail.com> <4F95D573.4080901@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 23 Apr 2012 16:05:53 -0700
Message-ID: <CAB=NE6V+2nCacTvcSqm8NE_RvzU5jMS4znxEYqZLyL2FZ0bqyw@mail.gmail.com> (sfid-20120424_010618_281196_726A29EB)
Subject: Re: [PATCH 1/2] compat: add module_pci_driver
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 23, 2012 at 3:19 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> On 04/23/2012 11:09 PM, Luis R. Rodriguez wrote:
>> On Sun, Apr 22, 2012 at 2:59 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>>> module_pci_driver is needed to register the pci driver to the pci sub system.
>>
>> Thanks ! I see no Signed-off-by tag on these though, I use the SOB tag
>> just as the kernel and other projects us it, the meaning of it is the
>> same, under the "Developer's Certificate of Origin 1.1":
>>
>> http://gerrit.googlecode.com/svn/documentation/2.0/user-signedoffby.html
>>
>> Do you SOB these patches?
>>
>>   Luis
> Hi Luis,
>
> I SOB these patches and the patches for compat-wireless I send also on
> that day. I forgot to add the option to generate a SOB line in git
> format-patch this time. Should I resend them with a SOB line or do you
> take this late SOB in this mail?

I take this late SOB, thanks!

 Luis
