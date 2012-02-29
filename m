Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:53237 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932662Ab2B2QVv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 11:21:51 -0500
Message-ID: <4F4E50A4.1090309@xenotime.net> (sfid-20120229_172216_821253_65D4F940)
Date: Wed, 29 Feb 2012 08:21:56 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
MIME-Version: 1.0
To: Mohammed Shafi <shafi.wireless@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: wireless-testing fail compiling
References: <1330374499.12612.18.camel@wwguy-huron>	<20120227232946.GG26664@tuxdriver.com> <CAD2nsn3+WK9FQ=xwGO22g6XsCRK2hO6Y7CAtjGRdJUu3Bmuwbg@mail.gmail.com>
In-Reply-To: <CAD2nsn3+WK9FQ=xwGO22g6XsCRK2hO6Y7CAtjGRdJUu3Bmuwbg@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/28/2012 11:51 PM, Mohammed Shafi wrote:

> On Tue, Feb 28, 2012 at 4:59 AM, John W. Linville
> <linville@tuxdriver.com> wrote:
>> On Mon, Feb 27, 2012 at 12:28:19PM -0800, Guy, Wey-Yi wrote:
>>> build break in the latest wireless-testing
>>>
>>> fs/autofs4/inode.c: In function ‘autofs4_fill_super’:
>>> fs/autofs4/inode.c:228: error: implicit declaration of function
>>> ‘is_compat_task’
>>> make[2]: *** [fs/autofs4/inode.o] Error 1
>>> make[1]: *** [fs/autofs4] Error 2
>>> make: *** [fs] Error 2
>>>
>>>
>>> fs/autofs4/dev-ioctl.c: In function ‘autofs_dev_ioctl_setpipefd’:
>>> fs/autofs4/dev-ioctl.c:388: error: implicit declaration of function
>>> ‘is_compat_task’
>>> make[2]: *** [fs/autofs4/dev-ioctl.o] Error 1
>>
>> It looks like that line was added in commit
>> a32744d4abae24572eff7269bc17895c41bd0085, which came into
>> wireless-testing as part of 3.3-rc5.
> 
> John, i  also got the same problem just trying the fix mentioned in
> https://lkml.org/lkml/2012/2/25/103


Huh?  You got the same problem after trying Linus's patch?

or you got the same problem (it's in 3.3-rc5 baseline) so you are
trying Linus's patch (which works) ??

-- 
~Randy
