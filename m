Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f193.google.com ([209.85.221.193]:65437 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634AbZF3SeV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2009 14:34:21 -0400
Received: by qyk31 with SMTP id 31so380296qyk.33
        for <linux-wireless@vger.kernel.org>; Tue, 30 Jun 2009 11:34:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090630182534.GA5758@sprite>
References: <20090630170916.GB5137@sprite> <43e72e890906301052l5a0b8984od8437fefa38e0dff@mail.gmail.com>
	<20090630182534.GA5758@sprite>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 30 Jun 2009 11:34:04 -0700
Message-ID: <43e72e890906301134k41d616b6oc4c159faf08fbec@mail.gmail.com>
Subject: Re: ath5k and Atheros AR242x - No scan results
To: Joel Roth <joelz@pobox.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 30, 2009 at 11:25 AM, Joel Roth<joelz@pobox.com> wrote:
> On Tue, Jun 30, 2009 at 10:52:09AM -0700, Luis R. Rodriguez wrote:
>> On Tue, Jun 30, 2009 at 10:09 AM, Joel Roth<joelz@pobox.com> wrote:
>>
>> sudo ip link set dev wlan0 up
>
> Hi Luis,
>
> I've tried this, with no obvious change.
>
> I've not used the 'ip' command before in my networking
> explorations, always relying on ifconfig to bring up
> devices.
>
> Ifconfig reports that wlan0 is UP. Is there any other
> kind of UP that I need to understand?
>
> Another question: From the point of view of setting up
> wireless, if the wlan0 device is UP, should
> 'iwlist scan' return a list of access points?
>
> Or are there any other conditions to be met?

http://wireless.kernel.org/en/users/Documentation/Reporting_bugs#Identifying_the_bug

   Luis
