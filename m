Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:62347 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbYJVJKG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 05:10:06 -0400
Received: by wf-out-1314.google.com with SMTP id 27so2931556wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2008 02:10:05 -0700 (PDT)
Message-ID: <1ba2fa240810220210w39466f2bobd1d6b32f99b533d@mail.gmail.com> (sfid-20081022_111012_603640_1EB5E8A3)
Date: Wed, 22 Oct 2008 11:10:05 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: New iwlwifi 3945 uCode available
Cc: "reinette chatre" <reinette.chatre@linux.intel.com>,
	"Marcel Holtmann" <holtmann@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1224660449.28639.22.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1224613633.10863.43.camel@rc-desk>
	 <1224624324.28639.9.camel@johannes.berg>
	 <1ba2fa240810211433q2e7a13b2p45cb8d38a74393c9@mail.gmail.com>
	 <1224624899.28639.17.camel@johannes.berg>
	 <20081021213814.GM17268@tuxdriver.com>
	 <1ba2fa240810211453y40739183v84999364c89886ee@mail.gmail.com>
	 <1224627187.9386.103.camel@californication>
	 <1224628088.10863.100.camel@rc-desk>
	 <1224660449.28639.22.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 22, 2008 at 9:27 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2008-10-21 at 15:28 -0700, reinette chatre wrote:
>
>> I do not believe our request is unreasonable. If a user runs a new
>> kernel the log will print a message that the firmware is incorrect ...
>> all the user needs to do is go to
>> http://intellinuxwireless.org/?n=Downloads and download the latest
>> firmware.
>
> And that exactly _is_ a problem, the user may be relying on wireless
> connectivity. And they won't know up-front they need new firmware. Since
> firmware is loaded from userspace, you're breaking userspace/kernel ABI,
> it's pretty simple really.
>
> I really don't know why we let you get away with this and bitch
> endlessly when b43 does such a change, to the point where we finally
> cave in and support both versions. Why should a community-supported
> driver be held to higher standards?

Patches that we'll support both firmwares from the cummutiy will be
welcome, as always.
Tomas
