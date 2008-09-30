Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:49150 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115AbYI3V5m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2008 17:57:42 -0400
Received: by fg-out-1718.google.com with SMTP id 19so181520fgg.17
        for <linux-wireless@vger.kernel.org>; Tue, 30 Sep 2008 14:57:35 -0700 (PDT)
Message-ID: <1ba2fa240809301457n427b0fe7o28ec9e43bcfcca7c@mail.gmail.com> (sfid-20080930_235746_797977_97226CB4)
Date: Wed, 1 Oct 2008 00:57:35 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: pull request: wireless-next-2.6 2008-09-30
Cc: "Johannes Berg" <johannes@sipsolutions.net>, davem@davemloft.net,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20080930200640.GG3765@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080930183938.GE3765@tuxdriver.com>
	 <1ba2fa240809301258o34b77ce2p737c229be7c0a2e9@mail.gmail.com>
	 <20080930200640.GG3765@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 30, 2008 at 11:06 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Tue, Sep 30, 2008 at 10:58:28PM +0300, Tomas Winkler wrote:
>> On Tue, Sep 30, 2008 at 9:39 PM, John W. Linville
>> <linville@tuxdriver.com> wrote:
>> > Dave,
>> >
>> > Here is the latest round of wireless bits intended for 2.6.28.  Among
>> > them is the first round of new stuff learned from the release of the
>> > Atheros HAL sources...
>> >
>> > Let me know if there are problems!
>> >
>> > Thanks,
>> >
>> > John
>>
>> What about this one
>> http://marc.info/?l=linux-wireless&m=122254550901882&w=2
>> It removes compilation warnings.
>
> Just didn't get to it yet, sorry.

It's not a real problem I just think we should at least strive for
clean compilation when merging upstream.

Tomas
