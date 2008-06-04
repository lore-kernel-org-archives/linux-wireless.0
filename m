Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.232]:8332 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbYFDSnv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2008 14:43:51 -0400
Received: by qb-out-0506.google.com with SMTP id q10so370503qbq.15
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jun 2008 11:43:50 -0700 (PDT)
Message-ID: <1ba2fa240806041143k2eb846b7m66132245851a408d@mail.gmail.com> (sfid-20080604_204355_634446_D4F1DB4B)
Date: Wed, 4 Jun 2008 21:43:49 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "maximilian attems" <max@stro.at>
Subject: Re: Page allocation failure in 2.6.26-rc2 (iwl4965 driver)
Cc: "Lukas Hejtmanek" <xhejtman@ics.muni.cz>, linux-mm@vger.kernel.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080604130452.GD9258@baikonur.stro.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080604130307.GN5012@ics.muni.cz>
	 <20080604130452.GD9258@baikonur.stro.at>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 4, 2008 at 4:04 PM, maximilian attems <max@stro.at> wrote:
> On Wed, Jun 04, 2008 at 03:03:07PM +0200, Lukas Hejtmanek wrote:
>> in the recent kernels I sometimes got the following allocation failure. It is
>> provoked by ifconfig wlan0 up. I have machine with 2GB RAM and 1.5GB of swap
>> (99% free). It happens if I start netbeans (which takes fair amount of memory)
>> and keep running netbeans whole night (so that updatedb and slocate are woken
>> up).
>

A patch that fixes this will come some.
Tomas
