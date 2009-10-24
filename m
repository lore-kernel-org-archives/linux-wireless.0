Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx03.syneticon.net ([78.111.66.105]:44933 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbZJXU7L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Oct 2009 16:59:11 -0400
Message-ID: <4AE36A89.8070105@wpkg.org>
Date: Sat, 24 Oct 2009 22:58:49 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: "Reserved instruction in kernel code" on ath9k insertion
References: <4AE35A9E.8000507@wpkg.org> <4AE36884.6060806@lwfinger.net>
In-Reply-To: <4AE36884.6060806@lwfinger.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger schrieb:

>> # modprobe ath9k
>> [  165.440000] Reserved instruction in kernel code[#1]:

(...)

>> [  165.440000] Code: 00000000  00000000  00000000 <00003009> 005196a8 
>> 005196a8  00000002  00000000  005166b0
>> [  165.440000] Disabling lock debugging due to kernel taint
>> Segmentation fault
>> #
> 
> Is that the start of the error dump?

Yes - as I do "modprobe", it starts to print the dump.
Then, modprobe segfaults.


> A BUG() statement places an
> illegal instruction in the code. Is that the case here?

I have no idea.


-- 
Tomasz Chmielewski
http://wpkg.org
