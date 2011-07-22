Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:58936 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917Ab1GVK6i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 06:58:38 -0400
Received: by yia27 with SMTP id 27so1132107yia.19
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jul 2011 03:58:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+icZUXXxQN1wSiwbNwDc5npFpB4AVVzawM=ssgkAvRbhhPp2Q@mail.gmail.com>
References: <CACna6rxbwQUQXOn_11WyXG0zjLq107oJZv7aHoZ3B8sF-4HuHA@mail.gmail.com>
	<CA+icZUXXxQN1wSiwbNwDc5npFpB4AVVzawM=ssgkAvRbhhPp2Q@mail.gmail.com>
Date: Fri, 22 Jul 2011 12:58:37 +0200
Message-ID: <CACna6rw7+KvLv_gcsx_fZhy4aaFBSFVedqnH5337JhFg7BQkrg@mail.gmail.com> (sfid-20110722_125842_185581_84EEE7B0)
Subject: Re: [ANNOUNCEMENT] BCM43224 and BCM43225 support thanks to Poznan
 University of Technology
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: sedat.dilek@gmail.com
Cc: b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 22 lipca 2011 12:56 użytkownik Sedat Dilek
<sedat.dilek@googlemail.com> napisał:
> 2011/7/22 Rafał Miłecki <zajec5@gmail.com>:
>> Hi guys,
>>
>> As you hopefully noticed, I've spent a lot of time on Broadcom's cards
>> in the last few months. Adding bcma, modifying b43, fixing some bugs,
>> and so on... Today I've finally proposed enabling BCM43224 and
>> BCM43225 support, with a little of luck, still for 3.1 kernel.
>>
>> I've time for all of that thanks to Poznan University of Technology
>> (the one I study at). After my first success with BCM4321 they
>> proposed me to continue this project as part of my MSc work. Thanks to
>> that I could fully focus on b43 and related projects. Focusing on
>> another MSc work woudn't give me so much time and wouldn't result in
>> so fast development.
>>
>> I would like to say big "Thank You" to the University. It was one of
>> the most enjoyable projects during my studies!
>>
>>
>> Now, get the latest code and give me feedback for your BCM43224 or BCM43225! :)
>>
>> --
>> Rafał
>> --
>
> First of all, a big thank you for all the work and to your University
> which supported you.
> From where shall people test? Does a GIT repository exist?
> Or you simply forgot to mention in your euphoria (I know it's end of semester)?

All the needed stuff is almost in witeless-testing git tree. The only
two patches you need to apply manually are recently sent:
[PATCH 1/2 3.1] b43: bus: fix memory corruption when setting driver's data
[PATCH 2/2 3.1???] b43: bcma: drop BROKEN

-- 
Rafał
