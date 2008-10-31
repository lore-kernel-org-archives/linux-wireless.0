Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:16502 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbYJaGKl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 02:10:41 -0400
Received: by yx-out-2324.google.com with SMTP id 8so456100yxm.1
        for <linux-wireless@vger.kernel.org>; Thu, 30 Oct 2008 23:10:40 -0700 (PDT)
Message-ID: <43e72e890810302310h4255cba3h6cde76c8fc5f7e9f@mail.gmail.com> (sfid-20081031_071048_132421_B8EFA5BD)
Date: Thu, 30 Oct 2008 23:10:40 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: pat-lkml <pat-lkml@erley.org>
Subject: Re: [RFC] wireless: Add 802.11d support
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <490A94B7.9070609@erley.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1225428211-17353-1-git-send-email-lrodriguez@atheros.com>
	 <490A94B7.9070609@erley.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 30, 2008 at 10:16 PM, pat-lkml <pat-lkml@erley.org> wrote:
> Luis R. Rodriguez wrote:
>
>>
>> This is not complete, I'm missing the reg.c part, but figured
>> I'd send it out for review to get comments now. Anyone know what the
>> country IE extension thing is? A quick glance at 11d gave me nothing.
>
> http://www.winncom.com/pdf/802.11d-2001.pdf
>
> Section 7.3.2.12
>
> Might answer your question.  I had the document open while reading up on
> this stuff.

Yeah that's the section I read most of the day, it doesn't mention it at all.

  Luis
