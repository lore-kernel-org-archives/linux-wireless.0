Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.225]:13291 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbYJ0KlX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2008 06:41:23 -0400
Received: by rv-out-0506.google.com with SMTP id k40so2070717rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 27 Oct 2008 03:41:22 -0700 (PDT)
Message-ID: <1ba2fa240810270341l9332ec3qeee761ba764d5617@mail.gmail.com> (sfid-20081027_114132_450800_86A28CB1)
Date: Mon, 27 Oct 2008 12:41:22 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: build warnings
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Chr <chunkeey@web.de>, mcgrof <mcgrof@gmail.com>
In-Reply-To: <1397eb932d5573ecf093fcbc82c02adb.squirrel@secure.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1224923050.27353.1.camel@johannes.berg>
	 <1ba2fa240810270330u15e3ce04y9d077904f48e04e7@mail.gmail.com>
	 <1397eb932d5573ecf093fcbc82c02adb.squirrel@secure.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 27, 2008 at 12:34 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Tomas Winkler wrote:
>> On Sat, Oct 25, 2008 at 10:24 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>>> just FYI in case you haven't seen them. the p54 one looks like a genuine
>>> problem.
>>>
>>> drivers/net/wireless/iwlwifi/iwl-scan.c:69: warning: 'scan_tx_ant'
>>> defined but not used
>>
>> Strange. This variable was removed in 'iwlwifi: unify tx antenna toggling'
>> patch
>
> odd. maybe I don't have the right tree here. Just mentioning the warnings
> because in my experienced different gcc versions differ.
>
Really odd, the lines are just not there. Try to diff to
wireless-testing master branch.
Tomas

>
