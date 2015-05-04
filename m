Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:34343 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbbEDP6O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2015 11:58:14 -0400
Received: by obfe9 with SMTP id e9so109372024obf.1
        for <linux-wireless@vger.kernel.org>; Mon, 04 May 2015 08:58:14 -0700 (PDT)
Message-ID: <55479714.1060007@lwfinger.net> (sfid-20150504_175821_067578_1CF17F04)
Date: Mon, 04 May 2015 10:58:12 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?TmVyaWp1cyBCYWxpxatuYXM=?=
	<nerijus@users.sourceforge.net>, linux-wireless@vger.kernel.org
Subject: Re: b43 AP does not work
References: <loom.20150502T183011-57@post.gmane.org>  <5544FFE5.5090706@lwfinger.net> <loom.20150502T190504-905@post.gmane.org>  <loom.20150502T191744-147@post.gmane.org> <1430752777.17017.2.camel@redhat.com> <loom.20150504T173700-271@post.gmane.org>
In-Reply-To: <loom.20150504T173700-271@post.gmane.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/04/2015 10:41 AM, Nerijus Baliūnas wrote:
> Dan Williams <dcbw@...> writes:
>
>>> Just FYI - "access point" mode of the NM applet works (in Gnome). But it
>>> would still be nice to have hostapd working.
>>
>> If you want to use hostapd on the card and the system is running
>> NetworkManager, you can tell NM to ignore the device through the
>> "unmanaged-devices" option in NetworkManager.conf.  manpages have more
>> details.
>
> But I don't want NM to ignore the device - I use the wifi card with NM
> as a client. But sometimes I'd like to use hostapd directly (as NM
> does not allow me to configure AP parameters - channel, wpa number,
> AP name and password). It was possible before, but not any more.

That is an applet problem. I use openSUSE 13.2 with a KDE desktop, and the 
Connection Manager lets me specify everything in your list but perhaps the WPA 
level, but why would you want to use anything less secure than WPA2?

You need to complain to your distro if they have a regression in the NM applet.

Larry


