Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2776 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751472Ab2EFHR5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 May 2012 03:17:57 -0400
Message-ID: <4FA62585.7070306@broadcom.com> (sfid-20120506_091835_255574_30B313CB)
Date: Sun, 6 May 2012 09:17:25 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "tommy.hong" <hongjiujing@126.com>
cc: frankyl@broadcom.com, linville@tuxdriver.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	sleffler@chromium.org
Subject: Re: about SDIO WIFI Stack Test
References: <430427b9.58da.1371cf6d747.Coremail.hongjiujing@126.com>
 <4FA5A270.5060101@broadcom.com>
 <34ae4b6.b0dd.1371f6e83cf.Coremail.hongjiujing@126.com>
In-Reply-To: <34ae4b6.b0dd.1371f6e83cf.Coremail.hongjiujing@126.com>
Content-Type: text/plain;
 charset=gbk
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/06/2012 01:56 AM, tommy.hong wrote:
> thanks,Arend,if i want to use wireless-testing,that means my SDIO WIFI driver should write under wireless-testing framework?

First a general remark on top-posting email replies. More explanation
can be found all over the internet so copy-paste the question in your
fav search engine.

A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?

Again, wireless-testing is not a testing framework. It is one out of
three repositories provided by John Linville. Each of which serves its
purpose.

If you look for a kernel testing framework you could try Autotest (see
[1]). I have not tried it, but there has been a presentation on a
wireless summit couple of years ago by Sam Leffler.

Gr. AvS

[1] http://autotest.github.com/

> ÔÚ 2012-05-06 05:58:08£¬"Arend van Spriel" <arend@broadcom.com> Ð´µÀ£º
>> On 05/05/2012 02:26 PM, tommy.hong wrote:
>>> Dear All:
>>>              Hi,I have watched http://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git,I recently join in a sdio wifi chip project,can there some good way to test SDIO WIFI Stack,which can output the wii driver/stack work routine,and are  there some good tools to test WIFI chip in general way?
>>>              Hope all of you can share,sorry to interrupt.
>>
>> I had to ready your email over a couple of times and probably still do
>> not understand what you are asking. Let me try anyway.
>>
>> Not sure why you are referring to wireless-testing. It is a source
>> repository containing the latest wireless code on laster release
>> candidate. It does not contain a test framework although you could see
>> the kernel itself as such.
>>
>> So to test your driver you have to rely on standard wireless and
>> networking tools. It all depends on what your test scenarios need
>> (throughput, rate vs. range, suspend/resume). In order to get output
>>from the driver a printk works miracles and debugfs can also make a lot
>> of driver data available in user-space.
>>
>> Hope it helps.
>>
>> Gr. AvS
>>
> 
> 
> 
> 
> --
>  Best Regards
>  Embedded Linux Software Developer in China
>  In theory, there is no difference between theory and practice. But, in practice, there is.
>  Follow me:
>  Sina WeiBo:http://weibo.com/hongjiujin
>  Linkedin:http://cn.linkedin.com/in/hongjiujin
>  Tel:+86 13675148249
>  Email:
>  Tommy.hong@Nanjing(hongjiujing@126.com)
> 
> 
>    


