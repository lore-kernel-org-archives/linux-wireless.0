Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:42524 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936202Ab3DHW72 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 18:59:28 -0400
Received: by mail-oa0-f43.google.com with SMTP id l10so6811089oag.16
        for <linux-wireless@vger.kernel.org>; Mon, 08 Apr 2013 15:59:27 -0700 (PDT)
Message-ID: <51634BCD.3060304@lwfinger.net> (sfid-20130409_005931_924664_B97DC563)
Date: Mon, 08 Apr 2013 17:59:25 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Sean MacLennan <seanm@seanm.ca>
CC: David Howells <dhowells@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	viro@ZenIV.linux.org.uk, linux-wireless@vger.kernel.org
Subject: Re: The rtl8192e procfs-based debug interface seems very broken
References: <17570.1365415364@warthog.procyon.org.uk> <51634550.3090300@lwfinger.net> <20130408184615.38b20264@lappy.seanm.ca>
In-Reply-To: <20130408184615.38b20264@lappy.seanm.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/08/2013 05:46 PM, Sean MacLennan wrote:
> The driver isn't optimal, but I use it daily in one laptop. So it does
> work, it just has a few quirks :D
>
> Is the procfs structure only used for debugging? Unless it is used by
> user mode tools, I have never used it. I may try quickly commenting it
> out and see if things still work.

As far as I know, it is only for debugging.

Larry


