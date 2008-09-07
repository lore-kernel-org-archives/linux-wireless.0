Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.187]:44030 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbYIGFlL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Sep 2008 01:41:11 -0400
Received: by fk-out-0910.google.com with SMTP id 18so728722fkq.5
        for <linux-wireless@vger.kernel.org>; Sat, 06 Sep 2008 22:41:09 -0700 (PDT)
Message-ID: <1ba2fa240809062241m67a0e0e5q19adaa3bb38b6480@mail.gmail.com> (sfid-20080907_074124_505915_1490B550)
Date: Sun, 7 Sep 2008 08:41:08 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Marcel Holtmann" <holtmann@linux.intel.com>
Subject: Re: [RFC PATCH 0/3] mac80211 dissasociation
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org
In-Reply-To: <1220749724.6714.128.camel@californication>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1220739259-16918-1-git-send-email-tomas.winkler@intel.com>
	 <1220749724.6714.128.camel@californication>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 7, 2008 at 4:08 AM, Marcel Holtmann
<holtmann@linux.intel.com> wrote:
> Hi Tomas,
>
>> This series should fix mac problems in disassociation
>> There are two basic problems disassociation in current implementation.
>> The order of steps in the dissociation flow and missing proper
>> disassociation when moving from one AP to another.
>
> it would be nice if you add the problem description into the commit
> messages of the actual patches. This helps to actually figure out the
> reason for these kind of changes and they are then stored together with
> the patch. We really have to be more verbose why we are doing things. If
> anyone has to go through one year old kernels and figure out why a
> change has been made, they are basically lost. I had to go through 7
> years old kernels in the past and every extra piece of information is so
> useful then.

Sure, this is just RFC series
Tomas
