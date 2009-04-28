Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.228]:37960 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbZD1XQU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Apr 2009 19:16:20 -0400
Received: by rv-out-0506.google.com with SMTP id f9so649194rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 28 Apr 2009 16:16:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890904281612h23347941h5b58d58c2f9822c5@mail.gmail.com>
References: <1240346638-18755-1-git-send-email-hauke@hauke-m.de>
	<1240346638-18755-2-git-send-email-hauke@hauke-m.de> <43e72e890904281612h23347941h5b58d58c2f9822c5@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 28 Apr 2009 16:16:00 -0700
Message-ID: <43e72e890904281616r16ff8293w621863a9ef06c812@mail.gmail.com> (sfid-20090429_011623_942483_6F90DE0F)
Subject: Re: [PATCH 2/2] [compat-2.6] Symbol ksize is not exported in kernel
	older than 2.6.29.
To: Hauke Mehrtens <hauke@hauke-m.de>, Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 28, 2009 at 4:12 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Tue, Apr 21, 2009 at 1:43 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>> This reverts commit ad80a7a983e36c6d8f4ae57e4c472deb9cf1391c from wireless-testing on older kernel versions.
>> Thanks Mathijs de Bruin for reporting.
>
> Thanks, all pending patches have been applied and a new tarball
> regenerated. Sorry for the delay, I was away on vacation.
>
> v2.6.30-rc3-22201-g807e823
> wireless-testing latest tag:
> master-2009-04-22

Bleh, just updated the tags, we now get the right tags:

v2.6.30-rc3-22201-g807e823
wireless-testing latest tag:
master-2009-04-28
This is compat-release:
master-2009-04-28

  Luis
