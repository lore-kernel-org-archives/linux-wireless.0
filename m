Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35193 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757784Ab1FVCef (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 22:34:35 -0400
Received: by iwn6 with SMTP id 6so332288iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jun 2011 19:34:34 -0700 (PDT)
Message-ID: <4E0154B7.2000204@lwfinger.net> (sfid-20110622_043450_884340_ABC0A14E)
Date: Tue, 21 Jun 2011 21:34:31 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: ali@internetdog.org
CC: linux-wireless@vger.kernel.org
Subject: Re: r8712u driver for the rtl8192su chip.
References: <776913.88107.qm@web161609.mail.bf1.yahoo.com> <4DC0312A.4040303@lwfinger.net> <BANLkTinw+jv8zBi29EKs2K2=tAJMYCEdgQ@mail.gmail.com> <4DC0669E.4040100@lwfinger.net> <BANLkTikxS_2wJEpijmYQy3nPy2-9pykxdA@mail.gmail.com> <4DC06BF3.6070208@lwfinger.net> <20110621124954.GA8462@internetdog.org> <4E011644.3070906@lwfinger.net> <20110622010057.GA12123@internetdog.org>
In-Reply-To: <20110622010057.GA12123@internetdog.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/21/2011 08:00 PM, Ali Bahar wrote:
> On Tue, Jun 21, 2011 at 05:08:04PM -0500, Larry Finger wrote:
>> On 06/21/2011 07:49 AM, Ali Bahar wrote:
>
>>> this is more of a quick FYI, regarding Staging's r8712u driver.
>
>>> root@hashbang Tue Jun 21 18:30:06 ~$ iwconfig wlan2 essid "h55m"
>>> Error for wireless request "Set ESSID" (8B1A) :
>>>      SET failed on device wlan2 ; Operation not permitted.
>>> root@hashbang Tue Jun 21 18:30:47 ~$ uname -r
>
>> is implemented. Your command failed because you ran the command as
>> an unprivileged user. Notice the differences in the error messages.
>
> How is root unprivileged? The shell-prompt shows the user.
>
> Right after the failure, I ran the exact same steps, in the same
> shell, on a different card of the same box. It worked, as it always
> has.

I have no idea what you are doing wrong, but I get the following:

finger@larrylap:~/wireless-testing-new> sudo iwconfig wlan9 essid junk
finger@larrylap:~/wireless-testing-new>

The above is with r8712u running on wireless-testing 3.0-rc4.

Larry
