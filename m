Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.191]:59460 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbYJOJBj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2008 05:01:39 -0400
Received: by ti-out-0910.google.com with SMTP id b6so1456278tic.23
        for <linux-wireless@vger.kernel.org>; Wed, 15 Oct 2008 02:01:37 -0700 (PDT)
Message-ID: <ea11fea30810150201i6f5649dyd6da42c4f7cdcb01@mail.gmail.com> (sfid-20081015_110202_008161_497F463D)
Date: Wed, 15 Oct 2008 14:31:37 +0530
From: "Manish Katiyar" <mkatiyar@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] libertas : Remove unused variable warning "old_channel" from drivers/net/wireless/libertas/cmd.c
Cc: "Dan Williams" <dcbw@redhat.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1224060475.27537.0.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <ea11fea30810130352i3cea0579g9950289254c8e628@mail.gmail.com>
	 <1224002213.1799.2.camel@localhost.localdomain>
	 <ea11fea30810150110s772b740fv38cc37645da53201@mail.gmail.com>
	 <1224060475.27537.0.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 15, 2008 at 2:17 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> [dropping libertas list, subscribers only]
>
> On Wed, 2008-10-15 at 13:40 +0530, Manish Katiyar wrote:
>> On Tue, Oct 14, 2008 at 10:06 PM, Dan Williams <dcbw@redhat.com> wrote:
>> > On Mon, 2008-10-13 at 16:22 +0530, Manish Katiyar wrote:
>> >> Below patch removes the following warning during compilation.
>> >>
>> >> drivers/net/wireless/libertas/cmd.c:826: warning: unused variable 'old_channel'
>> >>
>> >>
>> >> Signed-off-by : Manish Katiyar <mkatiyar@gmail.com>
>> >
>> > Acked-by: Dan Williams <dcbw@redhat.com>
>>
>> Hi Dan,
>>
>> A newbie question. Will you merge this patch or will I have to send it
>> to Andrew again acked by you ?
>
> John has already applied it, Andrew isn't typically involved with
> wireless.

Thanks a lot John.

>
> johannes
>
