Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:51513 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123Ab1FVCMt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 22:12:49 -0400
Received: by qyk29 with SMTP id 29so2447676qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jun 2011 19:12:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTinD=zRLioxjruqPCMa1hkG4nUxBEw@mail.gmail.com>
References: <776913.88107.qm@web161609.mail.bf1.yahoo.com> <4DC0312A.4040303@lwfinger.net>
 <BANLkTinw+jv8zBi29EKs2K2=tAJMYCEdgQ@mail.gmail.com> <4DC0669E.4040100@lwfinger.net>
 <BANLkTikxS_2wJEpijmYQy3nPy2-9pykxdA@mail.gmail.com> <4DC06BF3.6070208@lwfinger.net>
 <20110621124954.GA8462@internetdog.org> <4E011644.3070906@lwfinger.net>
 <20110622010057.GA12123@internetdog.org> <BANLkTinD=zRLioxjruqPCMa1hkG4nUxBEw@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Wed, 22 Jun 2011 04:12:28 +0200
Message-ID: <BANLkTim_i+qrhHsZwUKQ=DcXuk+uJ3k3Wg@mail.gmail.com> (sfid-20110622_041257_712005_1EECB0E6)
Subject: Re: r8712u driver for the rtl8192su chip.
To: Julian Calaby <julian.calaby@gmail.com>
Cc: ali@internetdog.org, Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 22, 2011 at 4:03 AM, Julian Calaby <julian.calaby@gmail.com> wrote:
> Ali,
>
> On Wed, Jun 22, 2011 at 11:00, Ali Bahar <ali@internetdog.org> wrote:
>> On Tue, Jun 21, 2011 at 05:08:04PM -0500, Larry Finger wrote:
>>> On 06/21/2011 07:49 AM, Ali Bahar wrote:
>>
>>> >this is more of a quick FYI, regarding Staging's r8712u driver.
>>
>>> >root@hashbang Tue Jun 21 18:30:06 ~$ iwconfig wlan2 essid "h55m"
>>> >Error for wireless request "Set ESSID" (8B1A) :
>>> >     SET failed on device wlan2 ; Operation not permitted.
>>> >root@hashbang Tue Jun 21 18:30:47 ~$ uname -r
>>
>> How is root unprivileged? The shell-prompt shows the user.
>
> In general, root prompts have a '#' at the end of the prompt, this one
> has a '$' which is indicative of a non-privileged user.

I'm pretty sure that is not true for Bash. Perhaps for csh or Dash.

>
> Thanks,
>
> --
> Julian Calaby
>
> Email: julian.calaby@gmail.com
> Profile: http://www.google.com/profiles/julian.calaby/
> .Plan: http://sites.google.com/site/juliancalaby/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
