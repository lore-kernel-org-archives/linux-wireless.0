Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:54400 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913Ab2B2Hvf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 02:51:35 -0500
Received: by vcqp1 with SMTP id p1so3166957vcq.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Feb 2012 23:51:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120227232946.GG26664@tuxdriver.com>
References: <1330374499.12612.18.camel@wwguy-huron>
	<20120227232946.GG26664@tuxdriver.com>
Date: Wed, 29 Feb 2012 13:21:34 +0530
Message-ID: <CAD2nsn3+WK9FQ=xwGO22g6XsCRK2hO6Y7CAtjGRdJUu3Bmuwbg@mail.gmail.com> (sfid-20120229_085138_727915_BEF2C886)
Subject: Re: wireless-testing fail compiling
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 28, 2012 at 4:59 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Mon, Feb 27, 2012 at 12:28:19PM -0800, Guy, Wey-Yi wrote:
>> build break in the latest wireless-testing
>>
>> fs/autofs4/inode.c: In function ‘autofs4_fill_super’:
>> fs/autofs4/inode.c:228: error: implicit declaration of function
>> ‘is_compat_task’
>> make[2]: *** [fs/autofs4/inode.o] Error 1
>> make[1]: *** [fs/autofs4] Error 2
>> make: *** [fs] Error 2
>>
>>
>> fs/autofs4/dev-ioctl.c: In function ‘autofs_dev_ioctl_setpipefd’:
>> fs/autofs4/dev-ioctl.c:388: error: implicit declaration of function
>> ‘is_compat_task’
>> make[2]: *** [fs/autofs4/dev-ioctl.o] Error 1
>
> It looks like that line was added in commit
> a32744d4abae24572eff7269bc17895c41bd0085, which came into
> wireless-testing as part of 3.3-rc5.

John, i  also got the same problem just trying the fix mentioned in
https://lkml.org/lkml/2012/2/25/103

-- 
thanks,
shafi
