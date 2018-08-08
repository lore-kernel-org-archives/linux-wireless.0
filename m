Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f175.google.com ([209.85.216.175]:44414 "EHLO
        mail-qt0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbeHHEnZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Aug 2018 00:43:25 -0400
Received: by mail-qt0-f175.google.com with SMTP id b15-v6so760499qtp.11
        for <linux-wireless@vger.kernel.org>; Tue, 07 Aug 2018 19:25:53 -0700 (PDT)
From: Dan Kosek <daniel.kosek@gmail.com>
Message-Id: <4857D51C-FA25-4E9A-9B89-E71D3ED5E30D@gmail.com> (sfid-20180808_042611_836321_9C053606)
Content-Type: multipart/mixed;
        boundary="Apple-Mail=_05342D18-2BFB-4528-B1B0-59A5380BD521"
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: Re: iw scanning broken?
Date: Tue, 7 Aug 2018 22:25:50 -0400
In-Reply-To: <D466CC31-C56F-46F0-B189-2B10702701C6@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
References: <C17ECAF6-E13C-40DB-A582-C9945D9BE7D7@gmail.com>
 <5B65FC42.3010604@broadcom.com>
 <0ED1D417-F3DA-41EC-BE23-B0D3F736D255@gmail.com>
 <5B681216.6010402@broadcom.com>
 <D466CC31-C56F-46F0-B189-2B10702701C6@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--Apple-Mail=_05342D18-2BFB-4528-B1B0-59A5380BD521
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Here are the log files from a Lenovo laptop I have Peppermint 7 running =
on.  It has an older 2.4GHz (802.11b/g) card inside and still fails =
using the =E2=80=9Cflush=E2=80=9D option.

The Raspberry PI3B runs perfectly using the =E2=80=9Cflush=E2=80=9D =
option.

Dan

Dan Kosek
daniel.kosek@gmail.com

--Apple-Mail=_05342D18-2BFB-4528-B1B0-59A5380BD521
Content-Disposition: attachment;
	filename=auth.log
Content-Type: application/octet-stream;
	x-unix-mode=0777;
	name="auth.log"
Content-Transfer-Encoding: 7bit

Jul 17 17:39:35 Joanie sudo:   dkosek : TTY=unknown ; PWD=/home/dkosek ; USER=root ; COMMAND=/usr/lib/linuxmint/mintUpdate/checkAPT.py
Jul 17 17:39:35 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Jul 17 17:39:45 Joanie sudo: pam_unix(sudo:session): session closed for user root
Jul 17 18:09:35 Joanie sudo:   dkosek : TTY=unknown ; PWD=/home/dkosek ; USER=root ; COMMAND=/usr/lib/linuxmint/mintUpdate/checkAPT.py
Jul 17 18:09:35 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Jul 17 18:09:44 Joanie sudo: pam_unix(sudo:session): session closed for user root
Jul 17 18:17:01 Joanie CRON[7655]: pam_unix(cron:session): session opened for user root by (uid=0)
Jul 17 18:17:01 Joanie CRON[7655]: pam_unix(cron:session): session closed for user root
Jul 17 18:39:35 Joanie sudo:   dkosek : TTY=unknown ; PWD=/home/dkosek ; USER=root ; COMMAND=/usr/lib/linuxmint/mintUpdate/checkAPT.py
Jul 17 18:39:35 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Jul 17 18:39:38 Joanie sudo: pam_unix(sudo:session): session closed for user root
Jul 17 19:09:35 Joanie sudo:   dkosek : TTY=unknown ; PWD=/home/dkosek ; USER=root ; COMMAND=/usr/lib/linuxmint/mintUpdate/checkAPT.py
Jul 17 19:09:35 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Jul 17 19:09:39 Joanie sudo: pam_unix(sudo:session): session closed for user root
Jul 17 19:17:01 Joanie CRON[8761]: pam_unix(cron:session): session opened for user root by (uid=0)
Jul 17 19:17:01 Joanie CRON[8761]: pam_unix(cron:session): session closed for user root
Jul 17 19:39:36 Joanie sudo:   dkosek : TTY=unknown ; PWD=/home/dkosek ; USER=root ; COMMAND=/usr/lib/linuxmint/mintUpdate/checkAPT.py
Jul 17 19:39:36 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Jul 17 19:39:39 Joanie sudo: pam_unix(sudo:session): session closed for user root
Jul 17 20:09:36 Joanie sudo:   dkosek : TTY=unknown ; PWD=/home/dkosek ; USER=root ; COMMAND=/usr/lib/linuxmint/mintUpdate/checkAPT.py
Jul 17 20:09:36 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Jul 17 20:09:39 Joanie sudo: pam_unix(sudo:session): session closed for user root
Jul 17 20:17:01 Joanie CRON[9881]: pam_unix(cron:session): session opened for user root by (uid=0)
Jul 17 20:17:01 Joanie CRON[9881]: pam_unix(cron:session): session closed for user root
Jul 17 20:35:19 Joanie systemd-logind[788]: Lid closed.
Jul 17 20:35:19 Joanie systemd-logind[788]: Suspending...
Aug  2 13:04:06 Joanie systemd-logind[788]: Lid opened.
Aug  2 13:04:07 Joanie systemd-logind[788]: Operation 'sleep' finished.
Aug  2 13:04:08 Joanie smbd: pam_unix(samba:session): session closed for user nobody
Aug  2 13:06:23 Joanie sudo:   dkosek : TTY=pts/0 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw dev wlp3s0 scan freq 2412
Aug  2 13:06:23 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  2 13:06:23 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  2 13:08:01 Joanie sudo:   dkosek : TTY=unknown ; PWD=/home/dkosek ; USER=root ; COMMAND=/usr/lib/linuxmint/mintUpdate/checkAPT.py
Aug  2 13:08:01 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  2 13:08:12 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  2 13:08:40 Joanie systemd-logind[788]: Lid closed.
Aug  2 13:08:40 Joanie systemd-logind[788]: Suspending...
Aug  4 07:59:44 Joanie systemd-logind[788]: Lid opened.
Aug  4 07:59:45 Joanie systemd-logind[788]: Operation 'sleep' finished.
Aug  4 07:59:55 Joanie sudo:   dkosek : TTY=pts/0 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw dev wlp3s0 scan freq 2412
Aug  4 07:59:55 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  4 07:59:55 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  4 08:02:18 Joanie sudo:   dkosek : TTY=pts/0 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iwlist dev wlp3s0 scan freq 2412
Aug  4 08:02:18 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  4 08:02:18 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  4 08:02:29 Joanie sudo:   dkosek : TTY=pts/0 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iwlist wlp3s0 scan freq 2412
Aug  4 08:02:29 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  4 08:02:29 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  4 08:02:40 Joanie sudo:   dkosek : TTY=pts/0 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iwlist wlp3s0 scan channel 1
Aug  4 08:02:40 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  4 08:02:40 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  4 08:02:50 Joanie sudo:   dkosek : TTY=pts/0 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iwlist
Aug  4 08:02:50 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  4 08:02:50 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  4 08:03:17 Joanie sudo:   dkosek : TTY=pts/0 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iwlist wlp3s0 scan
Aug  4 08:03:17 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  4 08:03:18 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  4 08:04:57 Joanie polkitd(authority=local): Operator of unix-session:c2 successfully authenticated as unix-user:dkosek to gain ONE-SHOT authorization for action com.ubuntu.pkexec.synaptic for unix-process:11517:4206378352 [/bin/sh /usr/bin/synaptic-pkexec] (owned by unix-user:dkosek)
Aug  4 08:04:57 Joanie pkexec: pam_unix(polkit-1:session): session opened for user root by (uid=1000)
Aug  4 08:04:57 Joanie pkexec: pam_systemd(polkit-1:session): Cannot create session: Already running in a session
Aug  4 08:04:57 Joanie pkexec: pam_ck_connector(polkit-1:session): cannot determine display-device
Aug  4 08:04:57 Joanie pkexec[11518]: dkosek: Executing command [USER=root] [TTY=unknown] [CWD=/home/dkosek] [COMMAND=/usr/sbin/synaptic]
Aug  4 08:07:09 Joanie sudo: pam_unix(sudo:auth): authentication failure; logname= uid=1000 euid=0 tty= ruser=dkosek rhost=  user=dkosek
Aug  4 08:07:10 Joanie sudo: pam_unix(sudo:auth): auth could not identify password for [dkosek]
Aug  4 08:07:10 Joanie sudo:   dkosek : 1 incorrect password attempt ; TTY=unknown ; PWD=/home/dkosek ; USER=root ; COMMAND=/usr/bin/linssid
Aug  4 08:07:16 Joanie sudo:   dkosek : TTY=unknown ; PWD=/home/dkosek ; USER=root ; COMMAND=/usr/bin/linssid
Aug  4 08:07:16 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  4 08:13:30 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  4 08:17:01 Joanie CRON[13392]: pam_unix(cron:session): session opened for user root by (uid=0)
Aug  4 08:17:01 Joanie CRON[13392]: pam_unix(cron:session): session closed for user root
Aug  4 08:18:31 Joanie systemd-logind[788]: Lid closed.
Aug  4 08:18:31 Joanie systemd-logind[788]: Suspending...
Aug  4 09:02:18 Joanie systemd-logind[788]: Lid opened.
Aug  4 09:02:19 Joanie systemd-logind[788]: Operation 'sleep' finished.
Aug  4 09:02:41 Joanie systemd-logind[788]: Power key pressed.
Aug  4 09:12:31 Joanie sudo:   dkosek : TTY=unknown ; PWD=/home/dkosek ; USER=root ; COMMAND=/usr/lib/linuxmint/mintUpdate/checkAPT.py
Aug  4 09:12:31 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  4 09:12:42 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  4 09:15:02 Joanie systemd-logind[788]: Lid closed.
Aug  4 09:15:02 Joanie systemd-logind[788]: Suspending...
Aug  4 22:28:32 Joanie systemd-logind[788]: Lid opened.
Aug  4 22:28:33 Joanie systemd-logind[788]: Operation 'sleep' finished.
Aug  4 22:29:07 Joanie sudo:   dkosek : TTY=pts/0 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2412
Aug  4 22:29:07 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  4 22:29:07 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  4 22:29:24 Joanie sudo:   dkosek : TTY=pts/0 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2412
Aug  4 22:29:24 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  4 22:29:24 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  4 22:29:38 Joanie sudo:   dkosek : TTY=pts/0 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2412 flush
Aug  4 22:29:38 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  4 22:29:38 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  4 22:29:52 Joanie sudo:   dkosek : TTY=pts/0 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2412 flush
Aug  4 22:29:52 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  4 22:29:52 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  4 22:36:26 Joanie sudo:   dkosek : TTY=pts/0 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2412 flush
Aug  4 22:36:26 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  4 22:36:26 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  4 22:37:22 Joanie sudo:   dkosek : TTY=pts/0 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2412 flush
Aug  4 22:37:22 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  4 22:37:22 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  4 22:37:34 Joanie sudo:   dkosek : TTY=pts/0 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2412 flush
Aug  4 22:37:34 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  4 22:37:34 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  4 22:37:37 Joanie sudo:   dkosek : TTY=pts/0 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2412 flush
Aug  4 22:37:37 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  4 22:37:37 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  4 22:37:38 Joanie sudo:   dkosek : TTY=pts/0 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2412 flush
Aug  4 22:37:38 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  4 22:37:38 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  4 22:38:40 Joanie sudo:   dkosek : TTY=pts/0 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2412 flush
Aug  4 22:38:40 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  4 22:38:40 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  4 22:38:46 Joanie sudo:   dkosek : TTY=pts/0 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2412
Aug  4 22:38:46 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  4 22:38:46 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  4 22:38:54 Joanie sudo:   dkosek : TTY=pts/0 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2412
Aug  4 22:38:54 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  4 22:38:54 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  4 22:39:02 Joanie sudo:   dkosek : TTY=pts/0 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2412
Aug  4 22:39:02 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  4 22:39:02 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  4 22:39:12 Joanie sudo:   dkosek : TTY=pts/0 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2412
Aug  4 22:39:12 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  4 22:39:12 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  4 22:39:14 Joanie sudo:   dkosek : TTY=pts/0 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2412
Aug  4 22:39:14 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  4 22:39:15 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  4 22:39:25 Joanie sudo:   dkosek : TTY=pts/0 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2412
Aug  4 22:39:25 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  4 22:39:25 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  4 22:39:42 Joanie sudo:   dkosek : TTY=pts/0 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2412
Aug  4 22:39:42 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  4 22:39:42 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  4 22:44:49 Joanie systemd-logind[788]: Lid closed.
Aug  4 22:44:49 Joanie systemd-logind[788]: Suspending...
Aug  5 16:07:46 Joanie systemd-logind[788]: Lid opened.
Aug  5 16:07:47 Joanie systemd-logind[788]: Operation 'sleep' finished.
Aug  5 16:09:44 Joanie systemd-logind[788]: Lid closed.
Aug  5 16:09:44 Joanie systemd-logind[788]: Suspending...
Aug  5 19:22:06 Joanie systemd-logind[788]: Lid opened.
Aug  5 19:22:07 Joanie systemd-logind[788]: Operation 'sleep' finished.
Aug  5 19:24:52 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs scan_long.js
Aug  5 19:24:52 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  5 19:24:53 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  5 19:25:24 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs scan_long.js
Aug  5 19:25:24 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  5 19:25:24 Joanie sudo:     root : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlan0 scan freq 5220 flush
Aug  5 19:25:24 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  5 19:25:24 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  5 19:25:24 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  5 19:27:29 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs scanner2.js
Aug  5 19:27:29 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  5 19:27:30 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  5 19:27:41 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs scan_long.js
Aug  5 19:27:41 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  5 19:27:41 Joanie sudo:     root : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 5220 flush
Aug  5 19:27:41 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  5 19:27:41 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  5 19:27:41 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  5 19:28:34 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs scan_long.js
Aug  5 19:28:34 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  5 19:28:34 Joanie sudo:     root : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 5220 flush
Aug  5 19:28:34 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  5 19:28:34 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  5 19:28:34 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  5 19:29:29 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs scan_long.js
Aug  5 19:29:29 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  5 19:29:29 Joanie sudo:     root : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 5220 flush
Aug  5 19:29:29 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  5 19:29:29 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  5 19:29:29 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  5 19:30:14 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs scan_long.js
Aug  5 19:30:14 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  5 19:30:15 Joanie sudo:     root : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan
Aug  5 19:30:15 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  5 19:30:16 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  5 19:30:16 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  5 19:30:51 Joanie sudo:   dkosek : TTY=unknown ; PWD=/home/dkosek ; USER=root ; COMMAND=/usr/lib/linuxmint/mintUpdate/checkAPT.py
Aug  5 19:30:51 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  5 19:30:54 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs scan_long.js
Aug  5 19:30:54 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  5 19:30:54 Joanie sudo:     root : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2412 flush
Aug  5 19:30:54 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  5 19:30:54 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  5 19:31:01 Joanie sudo: message repeated 2 times: [ pam_unix(sudo:session): session closed for user root]
Aug  5 19:32:22 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs scan_long.js
Aug  5 19:32:22 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  5 19:32:23 Joanie sudo:     root : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2412 flush
Aug  5 19:32:23 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  5 19:32:23 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  5 19:32:23 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  5 19:32:27 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs scan_long.js
Aug  5 19:32:27 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  5 19:32:28 Joanie sudo:     root : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2412 flush
Aug  5 19:32:28 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  5 19:32:28 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  5 19:32:28 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  5 19:32:30 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs scan_long.js
Aug  5 19:32:30 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  5 19:32:30 Joanie sudo:     root : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2412 flush
Aug  5 19:32:30 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  5 19:32:30 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  5 19:32:30 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  5 19:32:31 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs scan_long.js
Aug  5 19:32:31 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  5 19:32:32 Joanie sudo:     root : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2412 flush
Aug  5 19:32:32 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  5 19:32:32 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  5 19:32:32 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  5 19:32:37 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs scan_long.js
Aug  5 19:32:37 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  5 19:32:37 Joanie sudo:     root : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2412 flush
Aug  5 19:32:37 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  5 19:32:37 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  5 19:32:37 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  5 19:32:39 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs scan_long.js
Aug  5 19:32:39 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  5 19:32:39 Joanie sudo:     root : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2412 flush
Aug  5 19:32:39 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  5 19:32:39 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  5 19:32:39 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  5 19:32:41 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs scan_long.js
Aug  5 19:32:41 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  5 19:32:41 Joanie sudo:     root : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2412 flush
Aug  5 19:32:41 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  5 19:32:41 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  5 19:32:41 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  5 19:32:43 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs scan_long.js
Aug  5 19:32:43 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  5 19:32:43 Joanie sudo:     root : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2412 flush
Aug  5 19:32:43 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  5 19:32:43 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  5 19:32:43 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  5 19:32:44 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs scan_long.js
Aug  5 19:32:44 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  5 19:32:44 Joanie sudo:     root : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2412 flush
Aug  5 19:32:44 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  5 19:32:44 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  5 19:32:44 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  5 19:33:22 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs scan_long.js
Aug  5 19:33:22 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  5 19:33:22 Joanie sudo:     root : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2412 flush
Aug  5 19:33:22 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  5 19:33:22 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  5 19:33:22 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  5 19:33:24 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs scan_long.js
Aug  5 19:33:24 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  5 19:33:24 Joanie sudo:     root : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2412 flush
Aug  5 19:33:24 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  5 19:33:24 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  5 19:33:24 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  5 19:33:25 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs scan_long.js
Aug  5 19:33:25 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  5 19:33:25 Joanie sudo:     root : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2412 flush
Aug  5 19:33:25 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  5 19:33:25 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  5 19:33:25 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  5 19:33:27 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs scan_long.js
Aug  5 19:33:27 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  5 19:33:27 Joanie sudo:     root : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2412 flush
Aug  5 19:33:27 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  5 19:33:27 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  5 19:33:27 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  5 19:33:29 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs scan_long.js
Aug  5 19:33:29 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  5 19:33:30 Joanie sudo:     root : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2412 flush
Aug  5 19:33:30 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  5 19:33:30 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  5 19:33:30 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  5 19:37:26 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs scan_long.js
Aug  5 19:37:26 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  5 19:37:26 Joanie sudo:     root : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2412 flush
Aug  5 19:37:26 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  5 19:37:26 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  5 19:37:26 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  5 19:37:57 Joanie systemd-logind[788]: Lid closed.
Aug  5 19:37:57 Joanie systemd-logind[788]: Suspending...
Aug  7 22:04:21 Joanie systemd-logind[788]: Lid opened.
Aug  7 22:04:22 Joanie systemd-logind[788]: Operation 'sleep' finished.
Aug  7 22:08:33 Joanie sudo: pam_unix(sudo:auth): authentication failure; logname= uid=1000 euid=0 tty=/dev/pts/1 ruser=dkosek rhost=  user=dkosek
Aug  7 22:08:40 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs new_scan5.js
Aug  7 22:08:40 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:08:40 Joanie sudo:     root : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2437 flush
Aug  7 22:08:40 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:08:40 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:08:40 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:08:46 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs new_scan5.js
Aug  7 22:08:46 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:08:46 Joanie sudo:     root : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2437 flush
Aug  7 22:08:46 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:08:46 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:08:46 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:08:48 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs new_scan5.js
Aug  7 22:08:48 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:08:48 Joanie sudo:     root : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2437 flush
Aug  7 22:08:48 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:08:48 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:08:48 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:08:55 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs new_scan5.js
Aug  7 22:08:55 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:08:55 Joanie sudo:     root : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2437 flush
Aug  7 22:08:55 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:08:55 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:08:55 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:08:58 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs new_scan5.js
Aug  7 22:08:58 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:08:58 Joanie sudo:     root : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2437 flush
Aug  7 22:08:58 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:08:58 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:08:58 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:09:08 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs new_scan5.js
Aug  7 22:09:08 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:09:08 Joanie sudo:     root : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2437 flush
Aug  7 22:09:08 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:09:08 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:09:08 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:09:11 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs new_scan5.js
Aug  7 22:09:11 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:09:11 Joanie sudo:     root : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2437 flush
Aug  7 22:09:11 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:09:11 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:09:11 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:11:12 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs new_scan5.js
Aug  7 22:11:12 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:11:12 Joanie sudo:     root : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2437 flush
Aug  7 22:11:12 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:11:12 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:11:12 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:11:22 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs new_scan5.js
Aug  7 22:11:22 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:11:23 Joanie sudo:     root : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2437 flush
Aug  7 22:11:23 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:11:23 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:11:23 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:11:27 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs new_scan5.js
Aug  7 22:11:27 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:11:27 Joanie sudo:     root : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2437 flush
Aug  7 22:11:27 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:11:27 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:11:27 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:11:50 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs new_scan5.js
Aug  7 22:11:50 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:11:50 Joanie sudo:     root : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2437 flush
Aug  7 22:11:50 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:11:50 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:11:50 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:12:00 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs new_scan5.js
Aug  7 22:12:00 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:12:00 Joanie sudo:     root : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2437 flush
Aug  7 22:12:00 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:12:00 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:12:00 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:12:23 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs new_scan5.js
Aug  7 22:12:23 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:12:23 Joanie sudo:     root : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2437 flush
Aug  7 22:12:23 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:12:23 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:12:23 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:12:27 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs new_scan5.js
Aug  7 22:12:27 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:12:27 Joanie sudo:     root : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2437 flush
Aug  7 22:12:27 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:12:27 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:12:27 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:12:30 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs new_scan5.js
Aug  7 22:12:30 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:12:30 Joanie sudo:     root : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2437 flush
Aug  7 22:12:30 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:12:30 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:12:30 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:12:34 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs new_scan5.js
Aug  7 22:12:34 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:12:34 Joanie sudo:     root : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2437 flush
Aug  7 22:12:34 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:12:34 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:12:34 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:12:37 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs new_scan5.js
Aug  7 22:12:37 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:12:37 Joanie sudo:     root : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2437 flush
Aug  7 22:12:37 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:12:37 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:12:37 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:12:40 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs new_scan5.js
Aug  7 22:12:40 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:12:40 Joanie sudo:     root : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2437 flush
Aug  7 22:12:40 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:12:40 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:12:40 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:12:50 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs new_scan5.js
Aug  7 22:12:50 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:12:50 Joanie sudo:     root : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2437 flush
Aug  7 22:12:50 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:12:50 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:12:50 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:13:24 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs new_scan5.js
Aug  7 22:13:24 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:13:24 Joanie sudo:     root : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2437 flush
Aug  7 22:13:24 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:13:24 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:13:24 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:15:06 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs new_scan5.js
Aug  7 22:15:06 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:15:06 Joanie sudo:     root : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2437 flush
Aug  7 22:15:06 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:15:06 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:15:06 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:15:32 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs new_scan5.js
Aug  7 22:15:32 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:15:32 Joanie sudo:     root : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2437 flush
Aug  7 22:15:32 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:15:32 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:15:32 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:15:36 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs new_scan5.js
Aug  7 22:15:36 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:15:36 Joanie sudo:     root : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2437 flush
Aug  7 22:15:36 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:15:36 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:15:36 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:15:40 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs new_scan5.js
Aug  7 22:15:40 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:15:40 Joanie sudo:     root : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2437 flush
Aug  7 22:15:40 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:15:40 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:15:40 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:15:43 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/usr/bin/nodejs new_scan5.js
Aug  7 22:15:43 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:15:43 Joanie sudo:     root : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2437 flush
Aug  7 22:15:43 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:15:43 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:15:43 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:15:49 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2437 flush
Aug  7 22:15:49 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:15:49 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:15:53 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2437 flush
Aug  7 22:15:53 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:15:53 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:15:57 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2437 flush
Aug  7 22:15:57 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:15:58 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:16:05 Joanie sudo:   dkosek : TTY=pts/1 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2437 flush
Aug  7 22:16:05 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:16:05 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:16:27 Joanie sudo:   dkosek : TTY=pts/0 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan freq 2412
Aug  7 22:16:27 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:16:27 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:16:46 Joanie sudo:   dkosek : TTY=pts/0 ; PWD=/home/dkosek/Documents/Scanner ; USER=root ; COMMAND=/sbin/iw wlp3s0 scan
Aug  7 22:16:46 Joanie sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Aug  7 22:16:47 Joanie sudo: pam_unix(sudo:session): session closed for user root
Aug  7 22:17:01 Joanie CRON[18679]: pam_unix(cron:session): session opened for user root by (uid=0)
Aug  7 22:17:01 Joanie CRON[18679]: pam_unix(cron:session): session closed for user root

--Apple-Mail=_05342D18-2BFB-4528-B1B0-59A5380BD521
Content-Disposition: attachment;
	filename=dpkg.log
Content-Type: application/octet-stream;
	x-unix-mode=0777;
	name="dpkg.log"
Content-Transfer-Encoding: 7bit

2018-08-04 08:05:26 startup archives unpack
2018-08-04 08:05:27 install linssid:amd64 <none> 2.7-3
2018-08-04 08:05:27 status half-installed linssid:amd64 2.7-3
2018-08-04 08:05:27 status triggers-pending man-db:amd64 2.7.5-1
2018-08-04 08:05:27 status triggers-pending bamfdaemon:amd64 0.5.3~bzr0+16.04.20180209-0ubuntu1
2018-08-04 08:05:27 status triggers-pending desktop-file-utils:amd64 0.22-1ubuntu5.1
2018-08-04 08:05:27 status half-installed linssid:amd64 2.7-3
2018-08-04 08:05:27 status triggers-pending mime-support:all 3.59ubuntu1
2018-08-04 08:05:28 status unpacked linssid:amd64 2.7-3
2018-08-04 08:05:28 status unpacked linssid:amd64 2.7-3
2018-08-04 08:05:28 trigproc man-db:amd64 2.7.5-1 <none>
2018-08-04 08:05:28 status half-configured man-db:amd64 2.7.5-1
2018-08-04 08:05:28 status installed man-db:amd64 2.7.5-1
2018-08-04 08:05:28 trigproc bamfdaemon:amd64 0.5.3~bzr0+16.04.20180209-0ubuntu1 <none>
2018-08-04 08:05:28 status half-configured bamfdaemon:amd64 0.5.3~bzr0+16.04.20180209-0ubuntu1
2018-08-04 08:05:28 status installed bamfdaemon:amd64 0.5.3~bzr0+16.04.20180209-0ubuntu1
2018-08-04 08:05:28 trigproc desktop-file-utils:amd64 0.22-1ubuntu5.1 <none>
2018-08-04 08:05:28 status half-configured desktop-file-utils:amd64 0.22-1ubuntu5.1
2018-08-04 08:05:28 status installed desktop-file-utils:amd64 0.22-1ubuntu5.1
2018-08-04 08:05:28 trigproc mime-support:all 3.59ubuntu1 <none>
2018-08-04 08:05:28 status half-configured mime-support:all 3.59ubuntu1
2018-08-04 08:05:28 status installed mime-support:all 3.59ubuntu1
2018-08-04 08:05:28 startup packages configure
2018-08-04 08:05:28 configure linssid:amd64 2.7-3 <none>
2018-08-04 08:05:28 status unpacked linssid:amd64 2.7-3
2018-08-04 08:05:28 status half-configured linssid:amd64 2.7-3
2018-08-04 08:05:28 status installed linssid:amd64 2.7-3
2018-08-04 08:05:28 startup packages configure

--Apple-Mail=_05342D18-2BFB-4528-B1B0-59A5380BD521
Content-Disposition: attachment;
	filename=kern.log
Content-Type: application/octet-stream;
	x-unix-mode=0777;
	name="kern.log"
Content-Transfer-Encoding: 7bit

Jul 17 20:35:19 Joanie NetworkManager[866]: <info>  [1531874119.8775] manager: sleep requested (sleeping: no  enabled: yes)
Jul 17 20:35:19 Joanie NetworkManager[866]: <info>  [1531874119.8775] manager: sleeping...
Jul 17 20:35:19 Joanie NetworkManager[866]: <info>  [1531874119.8776] device (wlp3s0): state change: activated -> unmanaged (reason 'sleeping') [100 10 37]
Jul 17 20:35:19 Joanie NetworkManager[866]: <info>  [1531874119.9196] dhcp4 (wlp3s0): canceled DHCP transaction, DHCP client pid 5785
Jul 17 20:35:19 Joanie NetworkManager[866]: <info>  [1531874119.9196] dhcp4 (wlp3s0): state changed bound -> done
Jul 17 20:35:19 Joanie kernel: [8611028.028061] wlp3s0: deauthenticating from c0:8a:de:20:2f:68 by local choice (Reason: 3=DEAUTH_LEAVING)
Jul 17 20:35:19 Joanie NetworkManager[866]: <info>  [1531874119.9345] dns-mgr: Writing DNS information to /sbin/resolvconf
Jul 17 20:35:19 Joanie kernel: [8611028.053577] cfg80211: World regulatory domain updated:
Jul 17 20:35:19 Joanie kernel: [8611028.053584] cfg80211:  DFS Master region: unset
Jul 17 20:35:19 Joanie kernel: [8611028.053586] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
Jul 17 20:35:19 Joanie kernel: [8611028.053591] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
Jul 17 20:35:19 Joanie kernel: [8611028.053594] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
Jul 17 20:35:19 Joanie kernel: [8611028.053597] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
Jul 17 20:35:19 Joanie kernel: [8611028.053601] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (N/A)
Jul 17 20:35:19 Joanie kernel: [8611028.053604] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (0 s)
Jul 17 20:35:19 Joanie kernel: [8611028.053608] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
Jul 17 20:35:19 Joanie kernel: [8611028.053611] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
Jul 17 20:35:19 Joanie kernel: [8611028.053614] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
Jul 17 20:35:19 Joanie NetworkManager[866]: <info>  [1531874119.9536] manager: NetworkManager state is now ASLEEP
Jul 17 20:35:25 Joanie kernel: [8611033.799377] atkbd serio0: Unknown key pressed (translated set 2, code 0xf1 on isa0060/serio0).
Jul 17 20:35:25 Joanie kernel: [8611033.799437] atkbd serio0: Use 'setkeycodes e071 <keycode>' to make it known.
Jul 17 20:35:25 Joanie kernel: [8611033.810024] atkbd serio0: Unknown key released (translated set 2, code 0xf1 on isa0060/serio0).
Jul 17 20:35:25 Joanie kernel: [8611033.810030] atkbd serio0: Use 'setkeycodes e071 <keycode>' to make it known.
Jul 17 20:35:30 Joanie kernel: [8611038.128938] PM: Syncing filesystems ... done.
Jul 17 20:35:30 Joanie kernel: [8611038.155057] PM: Preparing system for sleep (mem)
Aug  2 13:04:06 Joanie kernel: [8611038.157630] Freezing user space processes ... (elapsed 0.002 seconds) done.
Aug  2 13:04:06 Joanie kernel: [8611038.159737] Freezing remaining freezable tasks ... (elapsed 0.086 seconds) done.
Aug  2 13:04:06 Joanie kernel: [8611038.246170] PM: Suspending system (mem)
Aug  2 13:04:06 Joanie kernel: [8611038.246253] Suspending console(s) (use no_console_suspend to debug)
Aug  2 13:04:06 Joanie kernel: [8611038.408951] sd 0:0:0:0: [sda] Synchronizing SCSI cache
Aug  2 13:04:06 Joanie kernel: [8611038.409771] sd 0:0:0:0: [sda] Stopping disk
Aug  2 13:04:06 Joanie kernel: [8611038.699650] PM: suspend of devices complete after 453.198 msecs
Aug  2 13:04:06 Joanie kernel: [8611038.715972] PM: late suspend of devices complete after 16.316 msecs
Aug  2 13:04:06 Joanie kernel: [8611038.717347] r8169 0000:09:00.0: System wakeup enabled by ACPI
Aug  2 13:04:06 Joanie kernel: [8611038.717744] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
Aug  2 13:04:06 Joanie kernel: [8611038.717958] ehci-pci 0000:00:1a.0: System wakeup enabled by ACPI
Aug  2 13:04:06 Joanie kernel: [8611038.732101] PM: noirq suspend of devices complete after 16.125 msecs
Aug  2 13:04:06 Joanie kernel: [8611038.732275] ACPI: Preparing to enter system sleep state S3
Aug  2 13:04:06 Joanie kernel: [8611038.919913] ACPI : EC: EC stopped
Aug  2 13:04:06 Joanie kernel: [8611038.919915] PM: Saving platform NVS memory
Aug  2 13:04:06 Joanie kernel: [8611038.920885] Disabling non-boot CPUs ...
Aug  2 13:04:06 Joanie kernel: [8611038.922332] smpboot: CPU 1 is now offline
Aug  2 13:04:06 Joanie kernel: [8611038.932993] Broke affinity for irq 16
Aug  2 13:04:06 Joanie kernel: [8611038.933005] Broke affinity for irq 23
Aug  2 13:04:06 Joanie kernel: [8611038.933011] Broke affinity for irq 26
Aug  2 13:04:06 Joanie kernel: [8611038.934052] smpboot: CPU 2 is now offline
Aug  2 13:04:06 Joanie kernel: [8611038.944966] Broke affinity for irq 1
Aug  2 13:04:06 Joanie kernel: [8611038.944977] Broke affinity for irq 9
Aug  2 13:04:06 Joanie kernel: [8611038.944983] Broke affinity for irq 12
Aug  2 13:04:06 Joanie kernel: [8611038.944989] Broke affinity for irq 16
Aug  2 13:04:06 Joanie kernel: [8611038.945000] Broke affinity for irq 23
Aug  2 13:04:06 Joanie kernel: [8611038.945004] Broke affinity for irq 24
Aug  2 13:04:06 Joanie kernel: [8611038.945007] Broke affinity for irq 25
Aug  2 13:04:06 Joanie kernel: [8611038.945009] Broke affinity for irq 26
Aug  2 13:04:06 Joanie kernel: [8611038.945011] Broke affinity for irq 29
Aug  2 13:04:06 Joanie kernel: [8611038.946055] smpboot: CPU 3 is now offline
Aug  2 13:04:06 Joanie kernel: [8611038.957535] ACPI: Low-level resume complete
Aug  2 13:04:06 Joanie kernel: [8611038.957595] ACPI : EC: EC started
Aug  2 13:04:06 Joanie kernel: [8611038.957596] PM: Restoring platform NVS memory
Aug  2 13:04:06 Joanie kernel: [8611038.958162] Enabling non-boot CPUs ...
Aug  2 13:04:06 Joanie kernel: [8611038.977513] x86: Booting SMP configuration:
Aug  2 13:04:06 Joanie kernel: [8611038.977514] smpboot: Booting Node 0 Processor 1 APIC 0x4
Aug  2 13:04:06 Joanie kernel: [8611038.980117]  cache: parent cpu1 should not be sleeping
Aug  2 13:04:06 Joanie kernel: [8611038.980358] CPU1 is up
Aug  2 13:04:06 Joanie kernel: [8611038.997531] smpboot: Booting Node 0 Processor 2 APIC 0x1
Aug  2 13:04:06 Joanie kernel: [8611039.000026]  cache: parent cpu2 should not be sleeping
Aug  2 13:04:06 Joanie kernel: [8611039.000266] CPU2 is up
Aug  2 13:04:06 Joanie kernel: [8611039.013580] smpboot: Booting Node 0 Processor 3 APIC 0x5
Aug  2 13:04:06 Joanie kernel: [8611039.016097]  cache: parent cpu3 should not be sleeping
Aug  2 13:04:06 Joanie kernel: [8611039.016334] CPU3 is up
Aug  2 13:04:06 Joanie kernel: [8611039.018927] ACPI: Waking up from system sleep state S3
Aug  2 13:04:06 Joanie kernel: [8611039.201517] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
Aug  2 13:04:06 Joanie kernel: [8611039.201587] ehci-pci 0000:00:1a.0: System wakeup disabled by ACPI
Aug  2 13:04:06 Joanie kernel: [8611039.201932] PM: noirq resume of devices complete after 16.519 msecs
Aug  2 13:04:06 Joanie kernel: [8611039.204077] PM: early resume of devices complete after 2.124 msecs
Aug  2 13:04:06 Joanie kernel: [8611039.204338] r8169 0000:09:00.0: System wakeup disabled by ACPI
Aug  2 13:04:06 Joanie kernel: [8611039.205588] sd 0:0:0:0: [sda] Starting disk
Aug  2 13:04:06 Joanie kernel: [8611039.258825] r8169 0000:09:00.0 enp9s0: link down
Aug  2 13:04:06 Joanie kernel: [8611039.313733] rtc_cmos 00:02: System wakeup disabled by ACPI
Aug  2 13:04:06 Joanie kernel: [8611039.433353] usb 1-1.3: reset full-speed USB device number 3 using ehci-pci
Aug  2 13:04:06 Joanie kernel: [8611039.437354] usb 2-1.2: reset high-speed USB device number 7 using ehci-pci
Aug  2 13:04:06 Joanie kernel: [8611039.525373] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug  2 13:04:06 Joanie kernel: [8611039.525635] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
Aug  2 13:04:06 Joanie kernel: [8611039.525639] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
Aug  2 13:04:06 Joanie kernel: [8611039.526182] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
Aug  2 13:04:06 Joanie kernel: [8611039.526185] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
Aug  2 13:04:06 Joanie kernel: [8611039.526482] ata1.00: configured for UDMA/133
Aug  2 13:04:06 Joanie kernel: [8611039.533326] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Aug  2 13:04:06 Joanie kernel: [8611039.533906] ata2.00: unexpected _GTF length (8)
Aug  2 13:04:06 Joanie kernel: [8611039.535365] ata2.00: unexpected _GTF length (8)
Aug  2 13:04:06 Joanie kernel: [8611039.535369] ata2.00: configured for UDMA/100
Aug  2 13:04:06 Joanie kernel: [8611039.541402] ata6: SATA link down (SStatus 0 SControl 300)
Aug  2 13:04:06 Joanie kernel: [8611039.549325] ata5: SATA link down (SStatus 0 SControl 300)
Aug  2 13:04:06 Joanie kernel: [8611039.597342] usb 1-1.6: reset full-speed USB device number 5 using ehci-pci
Aug  2 13:04:06 Joanie kernel: [8611039.601306] usb 2-1.4: reset high-speed USB device number 3 using ehci-pci
Aug  2 13:04:06 Joanie kernel: [8611039.702104] PM: resume of devices complete after 498.051 msecs
Aug  2 13:04:06 Joanie kernel: [8611039.702790] PM: Finishing wakeup.
Aug  2 13:04:06 Joanie kernel: [8611039.702792] Restarting tasks ... done.
Aug  2 13:04:06 Joanie kernel: [8611039.773444] video LNXVIDEO:01: Restoring backlight state
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.1162] manager: wake requested (sleeping: yes  enabled: yes)
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.1163] manager: waking up...
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.1164] device (enp9s0): state change: unavailable -> unmanaged (reason 'sleeping') [20 10 37]
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.1373] device (wlp3s0): state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
Aug  2 13:04:07 Joanie kernel: [8611040.139646] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
Aug  2 13:04:07 Joanie kernel: [8611040.139825] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  2 13:04:07 Joanie kernel: [8611040.147373] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  2 13:04:07 Joanie kernel: [8611040.147473] iwlwifi 0000:03:00.0: Radio type=0x0-0x0-0x3
Aug  2 13:04:07 Joanie kernel: [8611040.182802] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  2 13:04:07 Joanie kernel: [8611040.190302] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  2 13:04:07 Joanie kernel: [8611040.190401] iwlwifi 0000:03:00.0: Radio type=0x0-0x0-0x3
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.2256] device (enp9s0): state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
Aug  2 13:04:07 Joanie kernel: [8611040.225382] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
Aug  2 13:04:07 Joanie kernel: [8611040.227991] IPv6: ADDRCONF(NETDEV_UP): enp9s0: link is not ready
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.2823] manager: NetworkManager state is now DISCONNECTED
Aug  2 13:04:07 Joanie kernel: [8611040.282630] r8169 0000:09:00.0 enp9s0: link down
Aug  2 13:04:07 Joanie kernel: [8611040.282755] IPv6: ADDRCONF(NETDEV_UP): enp9s0: link is not ready
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.3323] device (wlp3s0): supplicant interface state: starting -> ready
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.3324] device (wlp3s0): state change: unavailable -> disconnected (reason 'supplicant-available') [20 30 42]
Aug  2 13:04:07 Joanie kernel: [8611040.334833] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
Aug  2 13:04:07 Joanie kernel: [8611040.364881] psmouse serio4: synaptics: queried max coordinates: x [..5856], y [..4938]
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.7877] device (wlp3s0): supplicant interface state: ready -> inactive
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.7922] policy: auto-activating connection 'VoicePlex'
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.7934] device (wlp3s0): Activation: starting connection 'VoicePlex' (cf0aa26d-621a-4742-bf42-0b0a1644f3ca)
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.7936] device (wlp3s0): state change: disconnected -> prepare (reason 'none') [30 40 0]
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.7938] manager: NetworkManager state is now CONNECTING
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.7945] device (wlp3s0): state change: prepare -> config (reason 'none') [40 50 0]
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.7951] device (wlp3s0): Activation: (wifi) access point 'VoicePlex' has security, but secrets are required.
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.7952] device (wlp3s0): state change: config -> need-auth (reason 'none') [50 60 0]
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.7994] device (wlp3s0): state change: need-auth -> prepare (reason 'none') [60 40 0]
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.8000] device (wlp3s0): state change: prepare -> config (reason 'none') [40 50 0]
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.8003] device (wlp3s0): Activation: (wifi) connection 'VoicePlex' has security, and secrets exist.  No new secrets needed.
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.8004] Config: added 'ssid' value 'VoicePlex'
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.8004] Config: added 'scan_ssid' value '1'
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.8005] Config: added 'key_mgmt' value 'WPA-PSK'
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.8005] Config: added 'auth_alg' value 'OPEN'
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.8005] Config: added 'psk' value '<omitted>'
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.8035] sup-iface[0xaa36e0,wlp3s0]: config: set interface ap_scan to 1
Aug  2 13:04:07 Joanie kernel: [8611040.817622] wlp3s0: authenticate with c0:8a:de:20:2f:68
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.8220] device (wlp3s0): supplicant interface state: inactive -> authenticating
Aug  2 13:04:07 Joanie kernel: [8611040.821344] wlp3s0: send auth to c0:8a:de:20:2f:68 (try 1/3)
Aug  2 13:04:07 Joanie kernel: [8611040.822859] wlp3s0: authenticated
Aug  2 13:04:07 Joanie kernel: [8611040.823050] wlp3s0: waiting for beacon from c0:8a:de:20:2f:68
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.8267] device (wlp3s0): supplicant interface state: authenticating -> associating
Aug  2 13:04:07 Joanie kernel: [8611040.849275] wlp3s0: associate with c0:8a:de:20:2f:68 (try 1/3)
Aug  2 13:04:07 Joanie kernel: [8611040.853294] wlp3s0: RX AssocResp from c0:8a:de:20:2f:68 (capab=0x431 status=0 aid=2)
Aug  2 13:04:07 Joanie kernel: [8611040.857276] wlp3s0: associated
Aug  2 13:04:07 Joanie kernel: [8611040.857381] IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s0: link becomes ready
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.8617] device (wlp3s0): supplicant interface state: associating -> 4-way handshake
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.8705] device (wlp3s0): supplicant interface state: 4-way handshake -> completed
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.8706] device (wlp3s0): Activation: (wifi) Stage 2 of 5 (Device Configure) successful.  Connected to wireless network 'VoicePlex'.
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.8707] device (wlp3s0): state change: config -> ip-config (reason 'none') [50 70 0]
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.8714] dhcp4 (wlp3s0): activation: beginning transaction (timeout in 45 seconds)
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.8769] dhcp4 (wlp3s0): dhclient started with pid 10205
Aug  2 13:04:08 Joanie NetworkManager[866]: <info>  [1533229448.3481]   address 10.10.10.100
Aug  2 13:04:08 Joanie NetworkManager[866]: <info>  [1533229448.3481]   plen 24 (255.255.255.0)
Aug  2 13:04:08 Joanie NetworkManager[866]: <info>  [1533229448.3482]   gateway 10.10.10.254
Aug  2 13:04:08 Joanie NetworkManager[866]: <info>  [1533229448.3482]   server identifier 10.10.10.254
Aug  2 13:04:08 Joanie NetworkManager[866]: <info>  [1533229448.3483]   lease time 86400
Aug  2 13:04:08 Joanie NetworkManager[866]: <info>  [1533229448.3483]   hostname 'Joanie'
Aug  2 13:04:08 Joanie NetworkManager[866]: <info>  [1533229448.3483]   nameserver '10.10.10.254'
Aug  2 13:04:08 Joanie NetworkManager[866]: <info>  [1533229448.3484] dhcp4 (wlp3s0): state changed unknown -> bound
Aug  2 13:04:08 Joanie NetworkManager[866]: <info>  [1533229448.3531] device (wlp3s0): state change: ip-config -> ip-check (reason 'none') [70 80 0]
Aug  2 13:04:08 Joanie NetworkManager[866]: <info>  [1533229448.3544] device (wlp3s0): state change: ip-check -> secondaries (reason 'none') [80 90 0]
Aug  2 13:04:08 Joanie NetworkManager[866]: <info>  [1533229448.3572] device (wlp3s0): state change: secondaries -> activated (reason 'none') [90 100 0]
Aug  2 13:04:08 Joanie NetworkManager[866]: <info>  [1533229448.3575] manager: NetworkManager state is now CONNECTED_LOCAL
Aug  2 13:04:08 Joanie NetworkManager[866]: <info>  [1533229448.3649] manager: NetworkManager state is now CONNECTED_GLOBAL
Aug  2 13:04:08 Joanie NetworkManager[866]: <info>  [1533229448.3651] policy: set 'VoicePlex' (wlp3s0) as default for IPv4 routing and DNS
Aug  2 13:04:08 Joanie NetworkManager[866]: <info>  [1533229448.3654] dns-mgr: Writing DNS information to /sbin/resolvconf
Aug  2 13:04:08 Joanie NetworkManager[866]: <info>  [1533229448.3752] device (wlp3s0): Activation: successful, device activated.
Aug  2 13:08:40 Joanie NetworkManager[866]: <info>  [1533229720.4805] manager: sleep requested (sleeping: no  enabled: yes)
Aug  2 13:08:40 Joanie NetworkManager[866]: <info>  [1533229720.4806] manager: sleeping...
Aug  2 13:08:40 Joanie NetworkManager[866]: <info>  [1533229720.4806] device (wlp3s0): state change: activated -> unmanaged (reason 'sleeping') [100 10 37]
Aug  2 13:08:40 Joanie NetworkManager[866]: <info>  [1533229720.5138] dhcp4 (wlp3s0): canceled DHCP transaction, DHCP client pid 10205
Aug  2 13:08:40 Joanie NetworkManager[866]: <info>  [1533229720.5139] dhcp4 (wlp3s0): state changed bound -> done
Aug  2 13:08:40 Joanie kernel: [8611324.337418] wlp3s0: deauthenticating from c0:8a:de:20:2f:68 by local choice (Reason: 3=DEAUTH_LEAVING)
Aug  2 13:08:40 Joanie NetworkManager[866]: <info>  [1533229720.5306] dns-mgr: Writing DNS information to /sbin/resolvconf
Aug  2 13:08:40 Joanie kernel: [8611324.356835] cfg80211: World regulatory domain updated:
Aug  2 13:08:40 Joanie kernel: [8611324.356842] cfg80211:  DFS Master region: unset
Aug  2 13:08:40 Joanie kernel: [8611324.356846] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
Aug  2 13:08:40 Joanie kernel: [8611324.356851] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
Aug  2 13:08:40 Joanie kernel: [8611324.356856] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
Aug  2 13:08:40 Joanie kernel: [8611324.356859] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
Aug  2 13:08:40 Joanie kernel: [8611324.356864] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (N/A)
Aug  2 13:08:40 Joanie kernel: [8611324.356869] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (0 s)
Aug  2 13:08:40 Joanie kernel: [8611324.356873] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
Aug  2 13:08:40 Joanie kernel: [8611324.356878] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
Aug  2 13:08:40 Joanie kernel: [8611324.356881] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
Aug  2 13:08:40 Joanie NetworkManager[866]: <info>  [1533229720.5528] manager: NetworkManager state is now ASLEEP
Aug  4 07:59:44 Joanie kernel: [8611334.434426] PM: Syncing filesystems ... done.
Aug  4 07:59:44 Joanie kernel: [8611334.448917] PM: Preparing system for sleep (mem)
Aug  4 07:59:44 Joanie kernel: [8611334.449226] Freezing user space processes ... (elapsed 0.002 seconds) done.
Aug  4 07:59:44 Joanie kernel: [8611334.451298] Freezing remaining freezable tasks ... (elapsed 0.077 seconds) done.
Aug  4 07:59:44 Joanie kernel: [8611334.528985] PM: Suspending system (mem)
Aug  4 07:59:44 Joanie kernel: [8611334.529079] Suspending console(s) (use no_console_suspend to debug)
Aug  4 07:59:44 Joanie kernel: [8611334.696044] sd 0:0:0:0: [sda] Synchronizing SCSI cache
Aug  4 07:59:44 Joanie kernel: [8611334.696856] sd 0:0:0:0: [sda] Stopping disk
Aug  4 07:59:44 Joanie kernel: [8611334.970277] PM: suspend of devices complete after 440.999 msecs
Aug  4 07:59:44 Joanie kernel: [8611334.983356] PM: late suspend of devices complete after 13.074 msecs
Aug  4 07:59:44 Joanie kernel: [8611334.984754] r8169 0000:09:00.0: System wakeup enabled by ACPI
Aug  4 07:59:44 Joanie kernel: [8611334.984830] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
Aug  4 07:59:44 Joanie kernel: [8611334.985130] ehci-pci 0000:00:1a.0: System wakeup enabled by ACPI
Aug  4 07:59:44 Joanie kernel: [8611334.999261] PM: noirq suspend of devices complete after 15.901 msecs
Aug  4 07:59:44 Joanie kernel: [8611334.999447] ACPI: Preparing to enter system sleep state S3
Aug  4 07:59:44 Joanie kernel: [8611335.187408] ACPI : EC: EC stopped
Aug  4 07:59:44 Joanie kernel: [8611335.187409] PM: Saving platform NVS memory
Aug  4 07:59:44 Joanie kernel: [8611335.188479] Disabling non-boot CPUs ...
Aug  4 07:59:44 Joanie kernel: [8611335.190210] smpboot: CPU 1 is now offline
Aug  4 07:59:44 Joanie kernel: [8611335.204406] Broke affinity for irq 16
Aug  4 07:59:44 Joanie kernel: [8611335.204419] Broke affinity for irq 23
Aug  4 07:59:44 Joanie kernel: [8611335.204427] Broke affinity for irq 26
Aug  4 07:59:44 Joanie kernel: [8611335.205475] smpboot: CPU 2 is now offline
Aug  4 07:59:44 Joanie kernel: [8611335.216186] Broke affinity for irq 1
Aug  4 07:59:44 Joanie kernel: [8611335.216197] Broke affinity for irq 9
Aug  4 07:59:44 Joanie kernel: [8611335.216203] Broke affinity for irq 12
Aug  4 07:59:44 Joanie kernel: [8611335.216210] Broke affinity for irq 16
Aug  4 07:59:44 Joanie kernel: [8611335.216220] Broke affinity for irq 23
Aug  4 07:59:44 Joanie kernel: [8611335.216225] Broke affinity for irq 24
Aug  4 07:59:44 Joanie kernel: [8611335.216227] Broke affinity for irq 25
Aug  4 07:59:44 Joanie kernel: [8611335.216229] Broke affinity for irq 26
Aug  4 07:59:44 Joanie kernel: [8611335.216232] Broke affinity for irq 29
Aug  4 07:59:44 Joanie kernel: [8611335.217262] smpboot: CPU 3 is now offline
Aug  4 07:59:44 Joanie kernel: [8611335.228681] ACPI: Low-level resume complete
Aug  4 07:59:44 Joanie kernel: [8611335.228741] ACPI : EC: EC started
Aug  4 07:59:44 Joanie kernel: [8611335.228741] PM: Restoring platform NVS memory
Aug  4 07:59:44 Joanie kernel: [8611335.229306] Enabling non-boot CPUs ...
Aug  4 07:59:44 Joanie kernel: [8611335.248666] x86: Booting SMP configuration:
Aug  4 07:59:44 Joanie kernel: [8611335.248667] smpboot: Booting Node 0 Processor 1 APIC 0x4
Aug  4 07:59:44 Joanie kernel: [8611335.251270]  cache: parent cpu1 should not be sleeping
Aug  4 07:59:44 Joanie kernel: [8611335.251509] CPU1 is up
Aug  4 07:59:44 Joanie kernel: [8611335.268684] smpboot: Booting Node 0 Processor 2 APIC 0x1
Aug  4 07:59:44 Joanie kernel: [8611335.271186]  cache: parent cpu2 should not be sleeping
Aug  4 07:59:44 Joanie kernel: [8611335.271427] CPU2 is up
Aug  4 07:59:44 Joanie kernel: [8611335.284732] smpboot: Booting Node 0 Processor 3 APIC 0x5
Aug  4 07:59:44 Joanie kernel: [8611335.287345]  cache: parent cpu3 should not be sleeping
Aug  4 07:59:44 Joanie kernel: [8611335.287582] CPU3 is up
Aug  4 07:59:44 Joanie kernel: [8611335.290181] ACPI: Waking up from system sleep state S3
Aug  4 07:59:44 Joanie kernel: [8611335.476626] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
Aug  4 07:59:44 Joanie kernel: [8611335.476664] ehci-pci 0000:00:1a.0: System wakeup disabled by ACPI
Aug  4 07:59:44 Joanie kernel: [8611335.477063] PM: noirq resume of devices complete after 16.497 msecs
Aug  4 07:59:44 Joanie kernel: [8611335.479249] PM: early resume of devices complete after 2.160 msecs
Aug  4 07:59:44 Joanie kernel: [8611335.479572] r8169 0000:09:00.0: System wakeup disabled by ACPI
Aug  4 07:59:44 Joanie kernel: [8611335.479852] sd 0:0:0:0: [sda] Starting disk
Aug  4 07:59:44 Joanie kernel: [8611335.533987] r8169 0000:09:00.0 enp9s0: link down
Aug  4 07:59:44 Joanie kernel: [8611335.589852] rtc_cmos 00:02: System wakeup disabled by ACPI
Aug  4 07:59:44 Joanie kernel: [8611335.708505] usb 1-1.3: reset full-speed USB device number 3 using ehci-pci
Aug  4 07:59:44 Joanie kernel: [8611335.708527] usb 2-1.4: reset high-speed USB device number 3 using ehci-pci
Aug  4 07:59:44 Joanie kernel: [8611335.812494] ata5: SATA link down (SStatus 0 SControl 300)
Aug  4 07:59:44 Joanie kernel: [8611335.812530] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Aug  4 07:59:44 Joanie kernel: [8611335.813135] ata2.00: unexpected _GTF length (8)
Aug  4 07:59:44 Joanie kernel: [8611335.814615] ata2.00: unexpected _GTF length (8)
Aug  4 07:59:44 Joanie kernel: [8611335.814619] ata2.00: configured for UDMA/100
Aug  4 07:59:44 Joanie kernel: [8611335.820487] ata6: SATA link down (SStatus 0 SControl 300)
Aug  4 07:59:44 Joanie kernel: [8611335.872494] usb 1-1.6: reset full-speed USB device number 5 using ehci-pci
Aug  4 07:59:44 Joanie kernel: [8611335.876543] usb 2-1.2: reset high-speed USB device number 7 using ehci-pci
Aug  4 07:59:44 Joanie kernel: [8611335.973716] PM: resume of devices complete after 494.491 msecs
Aug  4 07:59:44 Joanie kernel: [8611335.974407] PM: Finishing wakeup.
Aug  4 07:59:44 Joanie kernel: [8611335.974408] Restarting tasks ... done.
Aug  4 07:59:44 Joanie kernel: [8611336.048190] video LNXVIDEO:01: Restoring backlight state
Aug  4 07:59:44 Joanie kernel: [8611336.608600] psmouse serio4: synaptics: queried max coordinates: x [..5856], y [..4938]
Aug  4 07:59:44 Joanie kernel: [8611336.708481] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug  4 07:59:44 Joanie kernel: [8611336.709509] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
Aug  4 07:59:44 Joanie kernel: [8611336.709512] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
Aug  4 07:59:44 Joanie kernel: [8611336.710045] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
Aug  4 07:59:44 Joanie kernel: [8611336.710048] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
Aug  4 07:59:44 Joanie kernel: [8611336.712218] ata1.00: configured for UDMA/133
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.2320] manager: wake requested (sleeping: yes  enabled: yes)
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.2320] manager: waking up...
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.2321] device (enp9s0): state change: unavailable -> unmanaged (reason 'sleeping') [20 10 37]
Aug  4 07:59:45 Joanie kernel: [8611337.080259] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.2567] device (wlp3s0): state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
Aug  4 07:59:45 Joanie kernel: [8611337.080706] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  4 07:59:45 Joanie kernel: [8611337.088216] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  4 07:59:45 Joanie kernel: [8611337.088338] iwlwifi 0000:03:00.0: Radio type=0x0-0x0-0x3
Aug  4 07:59:45 Joanie kernel: [8611337.126232] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  4 07:59:45 Joanie kernel: [8611337.133738] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  4 07:59:45 Joanie kernel: [8611337.133839] iwlwifi 0000:03:00.0: Radio type=0x0-0x0-0x3
Aug  4 07:59:45 Joanie kernel: [8611337.166790] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.3454] device (enp9s0): state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
Aug  4 07:59:45 Joanie kernel: [8611337.168886] IPv6: ADDRCONF(NETDEV_UP): enp9s0: link is not ready
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.4038] manager: NetworkManager state is now DISCONNECTED
Aug  4 07:59:45 Joanie kernel: [8611337.225699] r8169 0000:09:00.0 enp9s0: link down
Aug  4 07:59:45 Joanie kernel: [8611337.225772] IPv6: ADDRCONF(NETDEV_UP): enp9s0: link is not ready
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.4566] device (wlp3s0): supplicant interface state: starting -> ready
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.4567] device (wlp3s0): state change: unavailable -> disconnected (reason 'supplicant-available') [20 30 42]
Aug  4 07:59:45 Joanie kernel: [8611337.279921] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.9221] device (wlp3s0): supplicant interface state: ready -> inactive
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.9304] policy: auto-activating connection 'VoicePlex'
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.9315] device (wlp3s0): Activation: starting connection 'VoicePlex' (cf0aa26d-621a-4742-bf42-0b0a1644f3ca)
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.9317] device (wlp3s0): state change: disconnected -> prepare (reason 'none') [30 40 0]
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.9319] manager: NetworkManager state is now CONNECTING
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.9326] device (wlp3s0): state change: prepare -> config (reason 'none') [40 50 0]
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.9330] device (wlp3s0): Activation: (wifi) access point 'VoicePlex' has security, but secrets are required.
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.9330] device (wlp3s0): state change: config -> need-auth (reason 'none') [50 60 0]
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.9423] device (wlp3s0): state change: need-auth -> prepare (reason 'none') [60 40 0]
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.9428] device (wlp3s0): state change: prepare -> config (reason 'none') [40 50 0]
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.9431] device (wlp3s0): Activation: (wifi) connection 'VoicePlex' has security, and secrets exist.  No new secrets needed.
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.9431] Config: added 'ssid' value 'VoicePlex'
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.9432] Config: added 'scan_ssid' value '1'
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.9432] Config: added 'key_mgmt' value 'WPA-PSK'
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.9432] Config: added 'auth_alg' value 'OPEN'
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.9432] Config: added 'psk' value '<omitted>'
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.9492] sup-iface[0xb0f640,wlp3s0]: config: set interface ap_scan to 1
Aug  4 07:59:45 Joanie kernel: [8611337.783889] wlp3s0: authenticate with c0:8a:de:20:2f:68
Aug  4 07:59:45 Joanie kernel: [8611337.785447] wlp3s0: send auth to c0:8a:de:20:2f:68 (try 1/3)
Aug  4 07:59:45 Joanie kernel: [8611337.788109] wlp3s0: authenticated
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.9665] device (wlp3s0): supplicant interface state: inactive -> associating
Aug  4 07:59:45 Joanie kernel: [8611337.792322] wlp3s0: associate with c0:8a:de:20:2f:68 (try 1/3)
Aug  4 07:59:45 Joanie kernel: [8611337.800423] wlp3s0: RX AssocResp from c0:8a:de:20:2f:68 (capab=0x431 status=0 aid=2)
Aug  4 07:59:45 Joanie kernel: [8611337.803737] wlp3s0: associated
Aug  4 07:59:45 Joanie kernel: [8611337.803812] IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s0: link becomes ready
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.9869] device (wlp3s0): supplicant interface state: associating -> 4-way handshake
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.9964] device (wlp3s0): supplicant interface state: 4-way handshake -> completed
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.9965] device (wlp3s0): Activation: (wifi) Stage 2 of 5 (Device Configure) successful.  Connected to wireless network 'VoicePlex'.
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.9967] device (wlp3s0): state change: config -> ip-config (reason 'none') [50 70 0]
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.9975] dhcp4 (wlp3s0): activation: beginning transaction (timeout in 45 seconds)
Aug  4 07:59:46 Joanie NetworkManager[866]: <info>  [1533383986.0009] dhcp4 (wlp3s0): dhclient started with pid 11181
Aug  4 07:59:46 Joanie NetworkManager[866]: <info>  [1533383986.4642]   address 10.10.10.100
Aug  4 07:59:46 Joanie NetworkManager[866]: <info>  [1533383986.4642]   plen 24 (255.255.255.0)
Aug  4 07:59:46 Joanie NetworkManager[866]: <info>  [1533383986.4642]   gateway 10.10.10.254
Aug  4 07:59:46 Joanie NetworkManager[866]: <info>  [1533383986.4642]   server identifier 10.10.10.254
Aug  4 07:59:46 Joanie NetworkManager[866]: <info>  [1533383986.4643]   lease time 86400
Aug  4 07:59:46 Joanie NetworkManager[866]: <info>  [1533383986.4643]   hostname 'Joanie'
Aug  4 07:59:46 Joanie NetworkManager[866]: <info>  [1533383986.4643]   nameserver '10.10.10.254'
Aug  4 07:59:46 Joanie NetworkManager[866]: <info>  [1533383986.4643] dhcp4 (wlp3s0): state changed unknown -> bound
Aug  4 07:59:46 Joanie NetworkManager[866]: <info>  [1533383986.4663] device (wlp3s0): state change: ip-config -> ip-check (reason 'none') [70 80 0]
Aug  4 07:59:46 Joanie NetworkManager[866]: <info>  [1533383986.4672] device (wlp3s0): state change: ip-check -> secondaries (reason 'none') [80 90 0]
Aug  4 07:59:46 Joanie NetworkManager[866]: <info>  [1533383986.4678] device (wlp3s0): state change: secondaries -> activated (reason 'none') [90 100 0]
Aug  4 07:59:46 Joanie NetworkManager[866]: <info>  [1533383986.4680] manager: NetworkManager state is now CONNECTED_LOCAL
Aug  4 07:59:46 Joanie NetworkManager[866]: <info>  [1533383986.4849] manager: NetworkManager state is now CONNECTED_GLOBAL
Aug  4 07:59:46 Joanie NetworkManager[866]: <info>  [1533383986.4851] policy: set 'VoicePlex' (wlp3s0) as default for IPv4 routing and DNS
Aug  4 07:59:46 Joanie NetworkManager[866]: <info>  [1533383986.4853] dns-mgr: Writing DNS information to /sbin/resolvconf
Aug  4 07:59:46 Joanie NetworkManager[866]: <info>  [1533383986.4943] device (wlp3s0): Activation: successful, device activated.
Aug  4 08:18:31 Joanie NetworkManager[866]: <info>  [1533385111.4108] manager: sleep requested (sleeping: no  enabled: yes)
Aug  4 08:18:31 Joanie NetworkManager[866]: <info>  [1533385111.4109] manager: sleeping...
Aug  4 08:18:31 Joanie NetworkManager[866]: <info>  [1533385111.4109] device (wlp3s0): state change: activated -> unmanaged (reason 'sleeping') [100 10 37]
Aug  4 08:18:31 Joanie NetworkManager[866]: <info>  [1533385111.4274] dhcp4 (wlp3s0): canceled DHCP transaction, DHCP client pid 11181
Aug  4 08:18:31 Joanie NetworkManager[866]: <info>  [1533385111.4275] dhcp4 (wlp3s0): state changed bound -> done
Aug  4 08:18:31 Joanie kernel: [8612464.623967] wlp3s0: deauthenticating from c0:8a:de:20:2f:68 by local choice (Reason: 3=DEAUTH_LEAVING)
Aug  4 08:18:31 Joanie NetworkManager[866]: <info>  [1533385111.4408] dns-mgr: Writing DNS information to /sbin/resolvconf
Aug  4 08:18:31 Joanie kernel: [8612464.646232] cfg80211: World regulatory domain updated:
Aug  4 08:18:31 Joanie kernel: [8612464.646238] cfg80211:  DFS Master region: unset
Aug  4 08:18:31 Joanie kernel: [8612464.646241] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
Aug  4 08:18:31 Joanie kernel: [8612464.646246] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
Aug  4 08:18:31 Joanie kernel: [8612464.646250] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
Aug  4 08:18:31 Joanie kernel: [8612464.646253] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
Aug  4 08:18:31 Joanie kernel: [8612464.646257] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (N/A)
Aug  4 08:18:31 Joanie kernel: [8612464.646262] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (0 s)
Aug  4 08:18:31 Joanie kernel: [8612464.646265] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
Aug  4 08:18:31 Joanie kernel: [8612464.646268] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
Aug  4 08:18:31 Joanie kernel: [8612464.646272] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
Aug  4 08:18:31 Joanie NetworkManager[866]: <info>  [1533385111.4625] manager: NetworkManager state is now ASLEEP
Aug  4 08:18:41 Joanie kernel: [8612474.709559] PM: Syncing filesystems ... done.
Aug  4 08:18:41 Joanie kernel: [8612474.725641] PM: Preparing system for sleep (mem)
Aug  4 09:02:18 Joanie kernel: [8612474.726296] Freezing user space processes ... (elapsed 0.002 seconds) done.
Aug  4 09:02:18 Joanie kernel: [8612474.728366] Freezing remaining freezable tasks ... (elapsed 0.077 seconds) done.
Aug  4 09:02:18 Joanie kernel: [8612474.805597] PM: Suspending system (mem)
Aug  4 09:02:18 Joanie kernel: [8612474.805676] Suspending console(s) (use no_console_suspend to debug)
Aug  4 09:02:18 Joanie kernel: [8612474.967104] sd 0:0:0:0: [sda] Synchronizing SCSI cache
Aug  4 09:02:18 Joanie kernel: [8612474.967246] sd 0:0:0:0: [sda] Stopping disk
Aug  4 09:02:18 Joanie kernel: [8612475.034007] PM: suspend of devices complete after 228.100 msecs
Aug  4 09:02:18 Joanie kernel: [8612475.049956] PM: late suspend of devices complete after 15.945 msecs
Aug  4 09:02:18 Joanie kernel: [8612475.051329] r8169 0000:09:00.0: System wakeup enabled by ACPI
Aug  4 09:02:18 Joanie kernel: [8612475.051420] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
Aug  4 09:02:18 Joanie kernel: [8612475.051599] ehci-pci 0000:00:1a.0: System wakeup enabled by ACPI
Aug  4 09:02:19 Joanie kernel: [8612475.065957] PM: noirq suspend of devices complete after 15.999 msecs
Aug  4 09:02:19 Joanie kernel: [8612475.066111] ACPI: Preparing to enter system sleep state S3
Aug  4 09:02:19 Joanie kernel: [8612475.253783] ACPI : EC: EC stopped
Aug  4 09:02:19 Joanie kernel: [8612475.253788] PM: Saving platform NVS memory
Aug  4 09:02:19 Joanie kernel: [8612475.253802] ACPI Exception: AE_BAD_PARAMETER, Returned by Handler for [EmbeddedControl] (20150930/evregion-297)
Aug  4 09:02:19 Joanie kernel: [8612475.253817] ACPI Error: Method parse/execution failed [\_SB.PCI0.LPCB.EC._Q26] (Node ffff8801334ba3e8), AE_BAD_PARAMETER (20150930/psparse-542)
Aug  4 09:02:19 Joanie kernel: [8612475.254568] Disabling non-boot CPUs ...
Aug  4 09:02:19 Joanie kernel: [8612475.255926] smpboot: CPU 1 is now offline
Aug  4 09:02:19 Joanie kernel: [8612475.267108] Broke affinity for irq 16
Aug  4 09:02:19 Joanie kernel: [8612475.267120] Broke affinity for irq 23
Aug  4 09:02:19 Joanie kernel: [8612475.267128] Broke affinity for irq 26
Aug  4 09:02:19 Joanie kernel: [8612475.268175] smpboot: CPU 2 is now offline
Aug  4 09:02:19 Joanie kernel: [8612475.278877] Broke affinity for irq 1
Aug  4 09:02:19 Joanie kernel: [8612475.278888] Broke affinity for irq 9
Aug  4 09:02:19 Joanie kernel: [8612475.278894] Broke affinity for irq 12
Aug  4 09:02:19 Joanie kernel: [8612475.278901] Broke affinity for irq 16
Aug  4 09:02:19 Joanie kernel: [8612475.278911] Broke affinity for irq 23
Aug  4 09:02:19 Joanie kernel: [8612475.278916] Broke affinity for irq 24
Aug  4 09:02:19 Joanie kernel: [8612475.278918] Broke affinity for irq 25
Aug  4 09:02:19 Joanie kernel: [8612475.278920] Broke affinity for irq 26
Aug  4 09:02:19 Joanie kernel: [8612475.278923] Broke affinity for irq 29
Aug  4 09:02:19 Joanie kernel: [8612475.279970] smpboot: CPU 3 is now offline
Aug  4 09:02:19 Joanie kernel: [8612475.295434] ACPI: Low-level resume complete
Aug  4 09:02:19 Joanie kernel: [8612475.295494] ACPI : EC: EC started
Aug  4 09:02:19 Joanie kernel: [8612475.295495] PM: Restoring platform NVS memory
Aug  4 09:02:19 Joanie kernel: [8612475.296079] Enabling non-boot CPUs ...
Aug  4 09:02:19 Joanie kernel: [8612475.315398] x86: Booting SMP configuration:
Aug  4 09:02:19 Joanie kernel: [8612475.315399] smpboot: Booting Node 0 Processor 1 APIC 0x4
Aug  4 09:02:19 Joanie kernel: [8612475.317998]  cache: parent cpu1 should not be sleeping
Aug  4 09:02:19 Joanie kernel: [8612475.318242] CPU1 is up
Aug  4 09:02:19 Joanie kernel: [8612475.335415] smpboot: Booting Node 0 Processor 2 APIC 0x1
Aug  4 09:02:19 Joanie kernel: [8612475.337915]  cache: parent cpu2 should not be sleeping
Aug  4 09:02:19 Joanie kernel: [8612475.338153] CPU2 is up
Aug  4 09:02:19 Joanie kernel: [8612475.351462] smpboot: Booting Node 0 Processor 3 APIC 0x5
Aug  4 09:02:19 Joanie kernel: [8612475.354070]  cache: parent cpu3 should not be sleeping
Aug  4 09:02:19 Joanie kernel: [8612475.354304] CPU3 is up
Aug  4 09:02:19 Joanie kernel: [8612475.356901] ACPI: Waking up from system sleep state S3
Aug  4 09:02:19 Joanie kernel: [8612475.539669] ehci-pci 0000:00:1a.0: System wakeup disabled by ACPI
Aug  4 09:02:19 Joanie kernel: [8612475.539754] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
Aug  4 09:02:19 Joanie kernel: [8612475.539836] PM: noirq resume of devices complete after 16.544 msecs
Aug  4 09:02:19 Joanie kernel: [8612475.541981] PM: early resume of devices complete after 2.124 msecs
Aug  4 09:02:19 Joanie kernel: [8612475.542289] r8169 0000:09:00.0: System wakeup disabled by ACPI
Aug  4 09:02:19 Joanie kernel: [8612475.542531] sd 0:0:0:0: [sda] Starting disk
Aug  4 09:02:19 Joanie kernel: [8612475.596759] r8169 0000:09:00.0 enp9s0: link down
Aug  4 09:02:19 Joanie kernel: [8612475.656557] rtc_cmos 00:02: System wakeup disabled by ACPI
Aug  4 09:02:19 Joanie kernel: [8612475.771220] usb 2-1.4: reset high-speed USB device number 3 using ehci-pci
Aug  4 09:02:19 Joanie kernel: [8612475.771239] usb 1-1.3: reset full-speed USB device number 3 using ehci-pci
Aug  4 09:02:19 Joanie kernel: [8612475.879263] ata6: SATA link down (SStatus 0 SControl 300)
Aug  4 09:02:19 Joanie kernel: [8612475.879297] ata5: SATA link down (SStatus 0 SControl 300)
Aug  4 09:02:19 Joanie kernel: [8612475.883220] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Aug  4 09:02:19 Joanie kernel: [8612475.883768] ata2.00: unexpected _GTF length (8)
Aug  4 09:02:19 Joanie kernel: [8612475.885333] ata2.00: unexpected _GTF length (8)
Aug  4 09:02:19 Joanie kernel: [8612475.885337] ata2.00: configured for UDMA/100
Aug  4 09:02:19 Joanie kernel: [8612475.935264] usb 1-1.6: reset full-speed USB device number 5 using ehci-pci
Aug  4 09:02:19 Joanie kernel: [8612475.939214] usb 2-1.2: reset high-speed USB device number 7 using ehci-pci
Aug  4 09:02:19 Joanie kernel: [8612476.036430] PM: resume of devices complete after 494.473 msecs
Aug  4 09:02:19 Joanie kernel: [8612476.037013] PM: Finishing wakeup.
Aug  4 09:02:19 Joanie kernel: [8612476.037014] Restarting tasks ... done.
Aug  4 09:02:19 Joanie kernel: [8612476.109376] video LNXVIDEO:01: Restoring backlight state
Aug  4 09:02:19 Joanie kernel: [8612476.671781] psmouse serio4: synaptics: queried max coordinates: x [..5856], y [..4938]
Aug  4 09:02:19 Joanie kernel: [8612476.811519] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug  4 09:02:19 Joanie kernel: [8612476.812561] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
Aug  4 09:02:19 Joanie kernel: [8612476.812565] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
Aug  4 09:02:19 Joanie kernel: [8612476.813240] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
Aug  4 09:02:19 Joanie kernel: [8612476.813243] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
Aug  4 09:02:19 Joanie kernel: [8612476.813450] ata1.00: configured for UDMA/133
Aug  4 09:02:19 Joanie NetworkManager[866]: <info>  [1533387739.9550] manager: wake requested (sleeping: yes  enabled: yes)
Aug  4 09:02:19 Joanie NetworkManager[866]: <info>  [1533387739.9551] manager: waking up...
Aug  4 09:02:19 Joanie NetworkManager[866]: <info>  [1533387739.9552] device (enp9s0): state change: unavailable -> unmanaged (reason 'sleeping') [20 10 37]
Aug  4 09:02:19 Joanie NetworkManager[866]: <info>  [1533387739.9771] device (wlp3s0): state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
Aug  4 09:02:19 Joanie kernel: [8612477.173556] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
Aug  4 09:02:19 Joanie kernel: [8612477.173945] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  4 09:02:19 Joanie kernel: [8612477.181451] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  4 09:02:19 Joanie kernel: [8612477.181552] iwlwifi 0000:03:00.0: Radio type=0x0-0x0-0x3
Aug  4 09:02:20 Joanie kernel: [8612477.216701] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  4 09:02:20 Joanie kernel: [8612477.224214] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  4 09:02:20 Joanie kernel: [8612477.224313] iwlwifi 0000:03:00.0: Radio type=0x0-0x0-0x3
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.0651] device (enp9s0): state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
Aug  4 09:02:20 Joanie kernel: [8612477.259799] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
Aug  4 09:02:20 Joanie kernel: [8612477.261524] IPv6: ADDRCONF(NETDEV_UP): enp9s0: link is not ready
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.1215] manager: NetworkManager state is now DISCONNECTED
Aug  4 09:02:20 Joanie kernel: [8612477.316471] r8169 0000:09:00.0 enp9s0: link down
Aug  4 09:02:20 Joanie kernel: [8612477.316577] IPv6: ADDRCONF(NETDEV_UP): enp9s0: link is not ready
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.1682] device (wlp3s0): supplicant interface state: starting -> ready
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.1684] device (wlp3s0): state change: unavailable -> disconnected (reason 'supplicant-available') [20 30 42]
Aug  4 09:02:20 Joanie kernel: [8612477.364754] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.6611] device (wlp3s0): supplicant interface state: ready -> inactive
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.6713] policy: auto-activating connection 'VoicePlex'
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.6729] device (wlp3s0): Activation: starting connection 'VoicePlex' (cf0aa26d-621a-4742-bf42-0b0a1644f3ca)
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.6734] device (wlp3s0): state change: disconnected -> prepare (reason 'none') [30 40 0]
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.6738] manager: NetworkManager state is now CONNECTING
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.6751] device (wlp3s0): state change: prepare -> config (reason 'none') [40 50 0]
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.6755] device (wlp3s0): Activation: (wifi) access point 'VoicePlex' has security, but secrets are required.
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.6756] device (wlp3s0): state change: config -> need-auth (reason 'none') [50 60 0]
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.6821] device (wlp3s0): state change: need-auth -> prepare (reason 'none') [60 40 0]
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.6826] device (wlp3s0): state change: prepare -> config (reason 'none') [40 50 0]
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.6829] device (wlp3s0): Activation: (wifi) connection 'VoicePlex' has security, and secrets exist.  No new secrets needed.
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.6831] Config: added 'ssid' value 'VoicePlex'
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.6831] Config: added 'scan_ssid' value '1'
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.6831] Config: added 'key_mgmt' value 'WPA-PSK'
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.6831] Config: added 'auth_alg' value 'OPEN'
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.6832] Config: added 'psk' value '<omitted>'
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.6842] sup-iface[0xb0f430,wlp3s0]: config: set interface ap_scan to 1
Aug  4 09:02:20 Joanie kernel: [8612477.893805] wlp3s0: authenticate with c0:8a:de:20:2f:68
Aug  4 09:02:20 Joanie kernel: [8612477.895360] wlp3s0: send auth to c0:8a:de:20:2f:68 (try 1/3)
Aug  4 09:02:20 Joanie kernel: [8612477.896864] wlp3s0: authenticated
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.7034] device (wlp3s0): supplicant interface state: inactive -> associating
Aug  4 09:02:20 Joanie kernel: [8612477.903048] wlp3s0: associate with c0:8a:de:20:2f:68 (try 1/3)
Aug  4 09:02:20 Joanie kernel: [8612477.906975] wlp3s0: RX AssocResp from c0:8a:de:20:2f:68 (capab=0x431 status=0 aid=4)
Aug  4 09:02:20 Joanie kernel: [8612477.910401] wlp3s0: associated
Aug  4 09:02:20 Joanie kernel: [8612477.910471] IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s0: link becomes ready
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.7206] device (wlp3s0): supplicant interface state: associating -> 4-way handshake
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.7288] device (wlp3s0): supplicant interface state: 4-way handshake -> completed
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.7292] device (wlp3s0): Activation: (wifi) Stage 2 of 5 (Device Configure) successful.  Connected to wireless network 'VoicePlex'.
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.7294] device (wlp3s0): state change: config -> ip-config (reason 'none') [50 70 0]
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.7309] dhcp4 (wlp3s0): activation: beginning transaction (timeout in 45 seconds)
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.7335] dhcp4 (wlp3s0): dhclient started with pid 13635
Aug  4 09:02:21 Joanie NetworkManager[866]: <info>  [1533387741.1776]   address 10.10.10.100
Aug  4 09:02:21 Joanie NetworkManager[866]: <info>  [1533387741.1777]   plen 24 (255.255.255.0)
Aug  4 09:02:21 Joanie NetworkManager[866]: <info>  [1533387741.1777]   gateway 10.10.10.254
Aug  4 09:02:21 Joanie NetworkManager[866]: <info>  [1533387741.1778]   server identifier 10.10.10.254
Aug  4 09:02:21 Joanie NetworkManager[866]: <info>  [1533387741.1778]   lease time 86400
Aug  4 09:02:21 Joanie NetworkManager[866]: <info>  [1533387741.1778]   hostname 'Joanie'
Aug  4 09:02:21 Joanie NetworkManager[866]: <info>  [1533387741.1779]   nameserver '10.10.10.254'
Aug  4 09:02:21 Joanie NetworkManager[866]: <info>  [1533387741.1779] dhcp4 (wlp3s0): state changed unknown -> bound
Aug  4 09:02:21 Joanie NetworkManager[866]: <info>  [1533387741.1812] device (wlp3s0): state change: ip-config -> ip-check (reason 'none') [70 80 0]
Aug  4 09:02:21 Joanie NetworkManager[866]: <info>  [1533387741.1825] device (wlp3s0): state change: ip-check -> secondaries (reason 'none') [80 90 0]
Aug  4 09:02:21 Joanie NetworkManager[866]: <info>  [1533387741.1833] device (wlp3s0): state change: secondaries -> activated (reason 'none') [90 100 0]
Aug  4 09:02:21 Joanie NetworkManager[866]: <info>  [1533387741.1836] manager: NetworkManager state is now CONNECTED_LOCAL
Aug  4 09:02:21 Joanie NetworkManager[866]: <info>  [1533387741.1968] manager: NetworkManager state is now CONNECTED_GLOBAL
Aug  4 09:02:21 Joanie NetworkManager[866]: <info>  [1533387741.1969] policy: set 'VoicePlex' (wlp3s0) as default for IPv4 routing and DNS
Aug  4 09:02:21 Joanie NetworkManager[866]: <info>  [1533387741.1972] dns-mgr: Writing DNS information to /sbin/resolvconf
Aug  4 09:02:21 Joanie NetworkManager[866]: <info>  [1533387741.2083] device (wlp3s0): Activation: successful, device activated.
Aug  4 09:15:02 Joanie NetworkManager[866]: <info>  [1533388502.8892] manager: sleep requested (sleeping: no  enabled: yes)
Aug  4 09:15:02 Joanie NetworkManager[866]: <info>  [1533388502.8892] manager: sleeping...
Aug  4 09:15:02 Joanie NetworkManager[866]: <info>  [1533388502.8893] device (wlp3s0): state change: activated -> unmanaged (reason 'sleeping') [100 10 37]
Aug  4 09:15:02 Joanie NetworkManager[866]: <info>  [1533388502.9061] dhcp4 (wlp3s0): canceled DHCP transaction, DHCP client pid 13635
Aug  4 09:15:02 Joanie NetworkManager[866]: <info>  [1533388502.9062] dhcp4 (wlp3s0): state changed bound -> done
Aug  4 09:15:02 Joanie kernel: [8613239.681103] wlp3s0: deauthenticating from c0:8a:de:20:2f:68 by local choice (Reason: 3=DEAUTH_LEAVING)
Aug  4 09:15:02 Joanie NetworkManager[866]: <info>  [1533388502.9291] dns-mgr: Writing DNS information to /sbin/resolvconf
Aug  4 09:15:02 Joanie kernel: [8613239.716099] cfg80211: World regulatory domain updated:
Aug  4 09:15:02 Joanie kernel: [8613239.716106] cfg80211:  DFS Master region: unset
Aug  4 09:15:02 Joanie kernel: [8613239.716108] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
Aug  4 09:15:02 Joanie kernel: [8613239.716113] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
Aug  4 09:15:02 Joanie kernel: [8613239.716117] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
Aug  4 09:15:02 Joanie kernel: [8613239.716120] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
Aug  4 09:15:02 Joanie kernel: [8613239.716125] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (N/A)
Aug  4 09:15:02 Joanie kernel: [8613239.716129] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (0 s)
Aug  4 09:15:02 Joanie kernel: [8613239.716133] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
Aug  4 09:15:02 Joanie kernel: [8613239.716136] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
Aug  4 09:15:02 Joanie kernel: [8613239.716140] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
Aug  4 09:15:02 Joanie NetworkManager[866]: <info>  [1533388502.9482] manager: NetworkManager state is now ASLEEP
Aug  4 22:28:32 Joanie kernel: [8613249.792077] PM: Syncing filesystems ... done.
Aug  4 22:28:32 Joanie kernel: [8613249.807855] PM: Preparing system for sleep (mem)
Aug  4 22:28:32 Joanie kernel: [8613249.808204] Freezing user space processes ... (elapsed 0.002 seconds) done.
Aug  4 22:28:32 Joanie kernel: [8613249.810624] Freezing remaining freezable tasks ... (elapsed 0.028 seconds) done.
Aug  4 22:28:32 Joanie kernel: [8613249.839480] PM: Suspending system (mem)
Aug  4 22:28:32 Joanie kernel: [8613249.839558] Suspending console(s) (use no_console_suspend to debug)
Aug  4 22:28:32 Joanie kernel: [8613249.997899] sd 0:0:0:0: [sda] Synchronizing SCSI cache
Aug  4 22:28:32 Joanie kernel: [8613249.998821] sd 0:0:0:0: [sda] Stopping disk
Aug  4 22:28:32 Joanie kernel: [8613250.291487] PM: suspend of devices complete after 451.732 msecs
Aug  4 22:28:32 Joanie kernel: [8613250.307178] PM: late suspend of devices complete after 15.687 msecs
Aug  4 22:28:32 Joanie kernel: [8613250.308503] r8169 0000:09:00.0: System wakeup enabled by ACPI
Aug  4 22:28:32 Joanie kernel: [8613250.308608] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
Aug  4 22:28:32 Joanie kernel: [8613250.308939] ehci-pci 0000:00:1a.0: System wakeup enabled by ACPI
Aug  4 22:28:32 Joanie kernel: [8613250.323285] PM: noirq suspend of devices complete after 16.102 msecs
Aug  4 22:28:32 Joanie kernel: [8613250.323492] ACPI: Preparing to enter system sleep state S3
Aug  4 22:28:32 Joanie kernel: [8613250.511065] ACPI : EC: EC stopped
Aug  4 22:28:32 Joanie kernel: [8613250.511068] PM: Saving platform NVS memory
Aug  4 22:28:32 Joanie kernel: [8613250.512280] Disabling non-boot CPUs ...
Aug  4 22:28:32 Joanie kernel: [8613250.513822] smpboot: CPU 1 is now offline
Aug  4 22:28:32 Joanie kernel: [8613250.524369] Broke affinity for irq 16
Aug  4 22:28:32 Joanie kernel: [8613250.524382] Broke affinity for irq 23
Aug  4 22:28:32 Joanie kernel: [8613250.524390] Broke affinity for irq 26
Aug  4 22:28:32 Joanie kernel: [8613250.525441] smpboot: CPU 2 is now offline
Aug  4 22:28:32 Joanie kernel: [8613250.540131] Broke affinity for irq 1
Aug  4 22:28:32 Joanie kernel: [8613250.540142] Broke affinity for irq 9
Aug  4 22:28:32 Joanie kernel: [8613250.540148] Broke affinity for irq 12
Aug  4 22:28:32 Joanie kernel: [8613250.540155] Broke affinity for irq 16
Aug  4 22:28:32 Joanie kernel: [8613250.540165] Broke affinity for irq 23
Aug  4 22:28:32 Joanie kernel: [8613250.540170] Broke affinity for irq 24
Aug  4 22:28:32 Joanie kernel: [8613250.540172] Broke affinity for irq 25
Aug  4 22:28:32 Joanie kernel: [8613250.540175] Broke affinity for irq 26
Aug  4 22:28:32 Joanie kernel: [8613250.540177] Broke affinity for irq 29
Aug  4 22:28:32 Joanie kernel: [8613250.541221] smpboot: CPU 3 is now offline
Aug  4 22:28:32 Joanie kernel: [8613250.552687] ACPI: Low-level resume complete
Aug  4 22:28:32 Joanie kernel: [8613250.552746] ACPI : EC: EC started
Aug  4 22:28:32 Joanie kernel: [8613250.552747] PM: Restoring platform NVS memory
Aug  4 22:28:32 Joanie kernel: [8613250.553312] Enabling non-boot CPUs ...
Aug  4 22:28:32 Joanie kernel: [8613250.572666] x86: Booting SMP configuration:
Aug  4 22:28:32 Joanie kernel: [8613250.572667] smpboot: Booting Node 0 Processor 1 APIC 0x4
Aug  4 22:28:32 Joanie kernel: [8613250.575271]  cache: parent cpu1 should not be sleeping
Aug  4 22:28:32 Joanie kernel: [8613250.575512] CPU1 is up
Aug  4 22:28:32 Joanie kernel: [8613250.592684] smpboot: Booting Node 0 Processor 2 APIC 0x1
Aug  4 22:28:32 Joanie kernel: [8613250.595183]  cache: parent cpu2 should not be sleeping
Aug  4 22:28:32 Joanie kernel: [8613250.595422] CPU2 is up
Aug  4 22:28:32 Joanie kernel: [8613250.608734] smpboot: Booting Node 0 Processor 3 APIC 0x5
Aug  4 22:28:32 Joanie kernel: [8613250.611249]  cache: parent cpu3 should not be sleeping
Aug  4 22:28:32 Joanie kernel: [8613250.611491] CPU3 is up
Aug  4 22:28:32 Joanie kernel: [8613250.614072] ACPI: Waking up from system sleep state S3
Aug  4 22:28:32 Joanie kernel: [8613250.796957] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
Aug  4 22:28:32 Joanie kernel: [8613250.796988] ehci-pci 0000:00:1a.0: System wakeup disabled by ACPI
Aug  4 22:28:32 Joanie kernel: [8613250.797120] PM: noirq resume of devices complete after 16.553 msecs
Aug  4 22:28:32 Joanie kernel: [8613250.799279] PM: early resume of devices complete after 2.138 msecs
Aug  4 22:28:32 Joanie kernel: [8613250.799592] r8169 0000:09:00.0: System wakeup disabled by ACPI
Aug  4 22:28:32 Joanie kernel: [8613250.804891] sd 0:0:0:0: [sda] Starting disk
Aug  4 22:28:32 Joanie kernel: [8613250.853961] r8169 0000:09:00.0 enp9s0: link down
Aug  4 22:28:32 Joanie kernel: [8613250.913560] rtc_cmos 00:02: System wakeup disabled by ACPI
Aug  4 22:28:32 Joanie kernel: [8613251.028509] usb 1-1.3: reset full-speed USB device number 3 using ehci-pci
Aug  4 22:28:32 Joanie kernel: [8613251.032540] usb 2-1.2: reset high-speed USB device number 7 using ehci-pci
Aug  4 22:28:32 Joanie kernel: [8613251.136495] ata5: SATA link down (SStatus 0 SControl 300)
Aug  4 22:28:32 Joanie kernel: [8613251.136533] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Aug  4 22:28:32 Joanie kernel: [8613251.137115] ata2.00: unexpected _GTF length (8)
Aug  4 22:28:32 Joanie kernel: [8613251.138575] ata2.00: unexpected _GTF length (8)
Aug  4 22:28:32 Joanie kernel: [8613251.138579] ata2.00: configured for UDMA/100
Aug  4 22:28:32 Joanie kernel: [8613251.144507] ata6: SATA link down (SStatus 0 SControl 300)
Aug  4 22:28:32 Joanie kernel: [8613251.192509] usb 1-1.6: reset full-speed USB device number 5 using ehci-pci
Aug  4 22:28:32 Joanie kernel: [8613251.196467] usb 2-1.4: reset high-speed USB device number 3 using ehci-pci
Aug  4 22:28:32 Joanie kernel: [8613251.297018] PM: resume of devices complete after 497.762 msecs
Aug  4 22:28:32 Joanie kernel: [8613251.297626] PM: Finishing wakeup.
Aug  4 22:28:32 Joanie kernel: [8613251.297628] Restarting tasks ... done.
Aug  4 22:28:32 Joanie kernel: [8613251.377309] video LNXVIDEO:01: Restoring backlight state
Aug  4 22:28:33 Joanie kernel: [8613251.930703] psmouse serio4: synaptics: queried max coordinates: x [..5856], y [..4938]
Aug  4 22:28:33 Joanie kernel: [8613252.076446] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug  4 22:28:33 Joanie kernel: [8613252.085838] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
Aug  4 22:28:33 Joanie kernel: [8613252.085841] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
Aug  4 22:28:33 Joanie kernel: [8613252.086477] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
Aug  4 22:28:33 Joanie kernel: [8613252.086481] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
Aug  4 22:28:33 Joanie kernel: [8613252.086686] ata1.00: configured for UDMA/133
Aug  4 22:28:33 Joanie NetworkManager[866]: <info>  [1533436113.9884] manager: wake requested (sleeping: yes  enabled: yes)
Aug  4 22:28:34 Joanie kernel: [8613252.458810] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
Aug  4 22:28:34 Joanie kernel: [8613252.459001] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436113.9884] manager: waking up...
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436113.9885] device (enp9s0): state change: unavailable -> unmanaged (reason 'sleeping') [20 10 37]
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.0051] device (wlp3s0): state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
Aug  4 22:28:34 Joanie kernel: [8613252.466674] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  4 22:28:34 Joanie kernel: [8613252.466775] iwlwifi 0000:03:00.0: Radio type=0x0-0x0-0x3
Aug  4 22:28:34 Joanie kernel: [8613252.502044] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  4 22:28:34 Joanie kernel: [8613252.509547] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  4 22:28:34 Joanie kernel: [8613252.509647] iwlwifi 0000:03:00.0: Radio type=0x0-0x0-0x3
Aug  4 22:28:34 Joanie kernel: [8613252.543423] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.0916] device (enp9s0): state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
Aug  4 22:28:34 Joanie kernel: [8613252.545323] IPv6: ADDRCONF(NETDEV_UP): enp9s0: link is not ready
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.1500] manager: NetworkManager state is now DISCONNECTED
Aug  4 22:28:34 Joanie kernel: [8613252.601835] r8169 0000:09:00.0 enp9s0: link down
Aug  4 22:28:34 Joanie kernel: [8613252.601931] IPv6: ADDRCONF(NETDEV_UP): enp9s0: link is not ready
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.2057] device (wlp3s0): supplicant interface state: starting -> ready
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.2059] device (wlp3s0): state change: unavailable -> disconnected (reason 'supplicant-available') [20 30 42]
Aug  4 22:28:34 Joanie kernel: [8613252.659783] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6295] device (wlp3s0): supplicant interface state: ready -> inactive
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6313] policy: auto-activating connection 'VoicePlex'
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6341] device (wlp3s0): Activation: starting connection 'VoicePlex' (cf0aa26d-621a-4742-bf42-0b0a1644f3ca)
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6345] device (wlp3s0): state change: disconnected -> prepare (reason 'none') [30 40 0]
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6349] manager: NetworkManager state is now CONNECTING
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6360] device (wlp3s0): state change: prepare -> config (reason 'none') [40 50 0]
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6364] device (wlp3s0): Activation: (wifi) access point 'VoicePlex' has security, but secrets are required.
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6364] device (wlp3s0): state change: config -> need-auth (reason 'none') [50 60 0]
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6428] device (wlp3s0): state change: need-auth -> prepare (reason 'none') [60 40 0]
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6434] device (wlp3s0): state change: prepare -> config (reason 'none') [40 50 0]
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6438] device (wlp3s0): Activation: (wifi) connection 'VoicePlex' has security, and secrets exist.  No new secrets needed.
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6438] Config: added 'ssid' value 'VoicePlex'
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6439] Config: added 'scan_ssid' value '1'
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6439] Config: added 'key_mgmt' value 'WPA-PSK'
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6439] Config: added 'auth_alg' value 'OPEN'
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6439] Config: added 'psk' value '<omitted>'
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6457] sup-iface[0xb0f590,wlp3s0]: config: set interface ap_scan to 1
Aug  4 22:28:34 Joanie kernel: [8613253.108894] wlp3s0: authenticate with c0:8a:de:20:2f:68
Aug  4 22:28:34 Joanie kernel: [8613253.110490] wlp3s0: send auth to c0:8a:de:20:2f:68 (try 1/3)
Aug  4 22:28:34 Joanie kernel: [8613253.112016] wlp3s0: authenticated
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6612] device (wlp3s0): supplicant interface state: inactive -> associating
Aug  4 22:28:34 Joanie kernel: [8613253.112526] wlp3s0: associate with c0:8a:de:20:2f:68 (try 1/3)
Aug  4 22:28:34 Joanie kernel: [8613253.116490] wlp3s0: RX AssocResp from c0:8a:de:20:2f:68 (capab=0x431 status=0 aid=3)
Aug  4 22:28:34 Joanie kernel: [8613253.120936] wlp3s0: associated
Aug  4 22:28:34 Joanie kernel: [8613253.121031] IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s0: link becomes ready
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6735] device (wlp3s0): supplicant interface state: associating -> 4-way handshake
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6809] device (wlp3s0): supplicant interface state: 4-way handshake -> completed
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6810] device (wlp3s0): Activation: (wifi) Stage 2 of 5 (Device Configure) successful.  Connected to wireless network 'VoicePlex'.
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6811] device (wlp3s0): state change: config -> ip-config (reason 'none') [50 70 0]
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6818] dhcp4 (wlp3s0): activation: beginning transaction (timeout in 45 seconds)
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6849] dhcp4 (wlp3s0): dhclient started with pid 14868
Aug  4 22:28:35 Joanie NetworkManager[866]: <info>  [1533436115.1392]   address 10.10.10.100
Aug  4 22:28:35 Joanie NetworkManager[866]: <info>  [1533436115.1393]   plen 24 (255.255.255.0)
Aug  4 22:28:35 Joanie NetworkManager[866]: <info>  [1533436115.1393]   gateway 10.10.10.254
Aug  4 22:28:35 Joanie NetworkManager[866]: <info>  [1533436115.1394]   server identifier 10.10.10.254
Aug  4 22:28:35 Joanie NetworkManager[866]: <info>  [1533436115.1394]   lease time 86400
Aug  4 22:28:35 Joanie NetworkManager[866]: <info>  [1533436115.1395]   hostname 'Joanie'
Aug  4 22:28:35 Joanie NetworkManager[866]: <info>  [1533436115.1395]   nameserver '10.10.10.254'
Aug  4 22:28:35 Joanie NetworkManager[866]: <info>  [1533436115.1396] dhcp4 (wlp3s0): state changed unknown -> bound
Aug  4 22:28:35 Joanie NetworkManager[866]: <info>  [1533436115.1454] device (wlp3s0): state change: ip-config -> ip-check (reason 'none') [70 80 0]
Aug  4 22:28:35 Joanie NetworkManager[866]: <info>  [1533436115.1464] device (wlp3s0): state change: ip-check -> secondaries (reason 'none') [80 90 0]
Aug  4 22:28:35 Joanie NetworkManager[866]: <info>  [1533436115.1472] device (wlp3s0): state change: secondaries -> activated (reason 'none') [90 100 0]
Aug  4 22:28:35 Joanie NetworkManager[866]: <info>  [1533436115.1527] manager: NetworkManager state is now CONNECTED_LOCAL
Aug  4 22:28:35 Joanie NetworkManager[866]: <info>  [1533436115.1591] manager: NetworkManager state is now CONNECTED_GLOBAL
Aug  4 22:28:35 Joanie NetworkManager[866]: <info>  [1533436115.1594] policy: set 'VoicePlex' (wlp3s0) as default for IPv4 routing and DNS
Aug  4 22:28:35 Joanie NetworkManager[866]: <info>  [1533436115.1597] dns-mgr: Writing DNS information to /sbin/resolvconf
Aug  4 22:28:35 Joanie NetworkManager[866]: <info>  [1533436115.1704] device (wlp3s0): Activation: successful, device activated.
Aug  4 22:43:11 Joanie kernel: [8614129.796881] usb 1-1.1: new high-speed USB device number 12 using ehci-pci
Aug  4 22:43:11 Joanie kernel: [8614129.895560] usb 1-1.1: New USB device found, idVendor=090c, idProduct=1000
Aug  4 22:43:11 Joanie kernel: [8614129.895569] usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Aug  4 22:43:11 Joanie kernel: [8614129.895575] usb 1-1.1: Product: Flash Drive
Aug  4 22:43:11 Joanie kernel: [8614129.895580] usb 1-1.1: Manufacturer: Samsung
Aug  4 22:43:11 Joanie kernel: [8614129.895585] usb 1-1.1: SerialNumber: 0375717070007140
Aug  4 22:43:11 Joanie kernel: [8614129.898349] usb-storage 1-1.1:1.0: USB Mass Storage device detected
Aug  4 22:43:11 Joanie kernel: [8614129.898652] scsi host13: usb-storage 1-1.1:1.0
Aug  4 22:43:11 Joanie kernel: [8614130.109311] usb 1-1.1: USB disconnect, device number 12
Aug  4 22:43:12 Joanie kernel: [8614130.820799] usb 1-1.1: new high-speed USB device number 13 using ehci-pci
Aug  4 22:43:12 Joanie kernel: [8614130.919468] usb 1-1.1: New USB device found, idVendor=090c, idProduct=1000
Aug  4 22:43:12 Joanie kernel: [8614130.919478] usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Aug  4 22:43:12 Joanie kernel: [8614130.919483] usb 1-1.1: Product: Flash Drive
Aug  4 22:43:12 Joanie kernel: [8614130.919488] usb 1-1.1: Manufacturer: Samsung
Aug  4 22:43:12 Joanie kernel: [8614130.919493] usb 1-1.1: SerialNumber: 0375717070007140
Aug  4 22:43:12 Joanie kernel: [8614130.920857] usb-storage 1-1.1:1.0: USB Mass Storage device detected
Aug  4 22:43:12 Joanie kernel: [8614130.922186] scsi host14: usb-storage 1-1.1:1.0
Aug  4 22:43:13 Joanie kernel: [8614132.140749] scsi 14:0:0:0: Direct-Access     Samsung  Flash Drive      1100 PQ: 0 ANSI: 6
Aug  4 22:43:13 Joanie kernel: [8614132.141428] sd 14:0:0:0: Attached scsi generic sg2 type 0
Aug  4 22:43:13 Joanie kernel: [8614132.142361] sd 14:0:0:0: [sdb] 62668800 512-byte logical blocks: (32.1 GB/29.9 GiB)
Aug  4 22:43:13 Joanie kernel: [8614132.143385] sd 14:0:0:0: [sdb] Write Protect is off
Aug  4 22:43:13 Joanie kernel: [8614132.143395] sd 14:0:0:0: [sdb] Mode Sense: 43 00 00 00
Aug  4 22:43:13 Joanie kernel: [8614132.144506] sd 14:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Aug  4 22:43:13 Joanie kernel: [8614132.154437]  sdb: sdb1
Aug  4 22:43:13 Joanie kernel: [8614132.158770] sd 14:0:0:0: [sdb] Attached SCSI removable disk
Aug  4 22:44:43 Joanie kernel: [8614221.751597] usb 1-1.1: USB disconnect, device number 13
Aug  4 22:44:49 Joanie NetworkManager[866]: <info>  [1533437089.3371] manager: sleep requested (sleeping: no  enabled: yes)
Aug  4 22:44:49 Joanie NetworkManager[866]: <info>  [1533437089.3371] manager: sleeping...
Aug  4 22:44:49 Joanie NetworkManager[866]: <info>  [1533437089.3372] device (wlp3s0): state change: activated -> unmanaged (reason 'sleeping') [100 10 37]
Aug  4 22:44:49 Joanie NetworkManager[866]: <info>  [1533437089.3697] dhcp4 (wlp3s0): canceled DHCP transaction, DHCP client pid 14868
Aug  4 22:44:49 Joanie NetworkManager[866]: <info>  [1533437089.3697] dhcp4 (wlp3s0): state changed bound -> done
Aug  4 22:44:49 Joanie kernel: [8614227.753656] wlp3s0: deauthenticating from c0:8a:de:20:2f:68 by local choice (Reason: 3=DEAUTH_LEAVING)
Aug  4 22:44:49 Joanie NetworkManager[866]: <info>  [1533437089.3852] dns-mgr: Writing DNS information to /sbin/resolvconf
Aug  4 22:44:49 Joanie kernel: [8614227.776650] cfg80211: World regulatory domain updated:
Aug  4 22:44:49 Joanie kernel: [8614227.776660] cfg80211:  DFS Master region: unset
Aug  4 22:44:49 Joanie kernel: [8614227.776663] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
Aug  4 22:44:49 Joanie kernel: [8614227.776669] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
Aug  4 22:44:49 Joanie kernel: [8614227.776673] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
Aug  4 22:44:49 Joanie kernel: [8614227.776677] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
Aug  4 22:44:49 Joanie kernel: [8614227.776683] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (N/A)
Aug  4 22:44:49 Joanie kernel: [8614227.776688] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (0 s)
Aug  4 22:44:49 Joanie kernel: [8614227.776693] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
Aug  4 22:44:49 Joanie kernel: [8614227.776698] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
Aug  4 22:44:49 Joanie kernel: [8614227.776702] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
Aug  4 22:44:49 Joanie NetworkManager[866]: <info>  [1533437089.4076] manager: NetworkManager state is now ASLEEP
Aug  5 16:07:46 Joanie kernel: [8614237.839865] PM: Syncing filesystems ... done.
Aug  5 16:07:46 Joanie kernel: [8614237.853599] PM: Preparing system for sleep (mem)
Aug  5 16:07:46 Joanie kernel: [8614237.853884] Freezing user space processes ... (elapsed 0.002 seconds) done.
Aug  5 16:07:46 Joanie kernel: [8614237.855968] Freezing remaining freezable tasks ... (elapsed 0.089 seconds) done.
Aug  5 16:07:46 Joanie kernel: [8614237.945332] PM: Suspending system (mem)
Aug  5 16:07:46 Joanie kernel: [8614237.945420] Suspending console(s) (use no_console_suspend to debug)
Aug  5 16:07:46 Joanie kernel: [8614238.108362] sd 0:0:0:0: [sda] Synchronizing SCSI cache
Aug  5 16:07:46 Joanie kernel: [8614238.109165] sd 0:0:0:0: [sda] Stopping disk
Aug  5 16:07:46 Joanie kernel: [8614238.389141] PM: suspend of devices complete after 443.531 msecs
Aug  5 16:07:46 Joanie kernel: [8614238.405219] PM: late suspend of devices complete after 16.073 msecs
Aug  5 16:07:46 Joanie kernel: [8614238.406351] r8169 0000:09:00.0: System wakeup enabled by ACPI
Aug  5 16:07:46 Joanie kernel: [8614238.406605] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
Aug  5 16:07:46 Joanie kernel: [8614238.406788] ehci-pci 0000:00:1a.0: System wakeup enabled by ACPI
Aug  5 16:07:46 Joanie kernel: [8614238.421198] PM: noirq suspend of devices complete after 15.977 msecs
Aug  5 16:07:46 Joanie kernel: [8614238.421347] ACPI: Preparing to enter system sleep state S3
Aug  5 16:07:46 Joanie kernel: [8614238.605317] ACPI : EC: EC stopped
Aug  5 16:07:46 Joanie kernel: [8614238.605318] PM: Saving platform NVS memory
Aug  5 16:07:46 Joanie kernel: [8614238.605905] Disabling non-boot CPUs ...
Aug  5 16:07:46 Joanie kernel: [8614238.607225] smpboot: CPU 1 is now offline
Aug  5 16:07:46 Joanie kernel: [8614238.617797] Broke affinity for irq 16
Aug  5 16:07:46 Joanie kernel: [8614238.617807] Broke affinity for irq 23
Aug  5 16:07:46 Joanie kernel: [8614238.617811] Broke affinity for irq 26
Aug  5 16:07:46 Joanie kernel: [8614238.618832] smpboot: CPU 2 is now offline
Aug  5 16:07:46 Joanie kernel: [8614238.629676] Broke affinity for irq 1
Aug  5 16:07:46 Joanie kernel: [8614238.629684] Broke affinity for irq 9
Aug  5 16:07:46 Joanie kernel: [8614238.629689] Broke affinity for irq 12
Aug  5 16:07:46 Joanie kernel: [8614238.629694] Broke affinity for irq 16
Aug  5 16:07:46 Joanie kernel: [8614238.629703] Broke affinity for irq 23
Aug  5 16:07:46 Joanie kernel: [8614238.629706] Broke affinity for irq 24
Aug  5 16:07:46 Joanie kernel: [8614238.629707] Broke affinity for irq 25
Aug  5 16:07:46 Joanie kernel: [8614238.629709] Broke affinity for irq 26
Aug  5 16:07:46 Joanie kernel: [8614238.629710] Broke affinity for irq 29
Aug  5 16:07:46 Joanie kernel: [8614238.630726] smpboot: CPU 3 is now offline
Aug  5 16:07:46 Joanie kernel: [8614238.642655] ACPI: Low-level resume complete
Aug  5 16:07:46 Joanie kernel: [8614238.642715] ACPI : EC: EC started
Aug  5 16:07:46 Joanie kernel: [8614238.642716] PM: Restoring platform NVS memory
Aug  5 16:07:46 Joanie kernel: [8614238.643280] Enabling non-boot CPUs ...
Aug  5 16:07:46 Joanie kernel: [8614238.662640] x86: Booting SMP configuration:
Aug  5 16:07:46 Joanie kernel: [8614238.662641] smpboot: Booting Node 0 Processor 1 APIC 0x4
Aug  5 16:07:46 Joanie kernel: [8614238.665238]  cache: parent cpu1 should not be sleeping
Aug  5 16:07:46 Joanie kernel: [8614238.665480] CPU1 is up
Aug  5 16:07:46 Joanie kernel: [8614238.682655] smpboot: Booting Node 0 Processor 2 APIC 0x1
Aug  5 16:07:46 Joanie kernel: [8614238.685156]  cache: parent cpu2 should not be sleeping
Aug  5 16:07:46 Joanie kernel: [8614238.685396] CPU2 is up
Aug  5 16:07:46 Joanie kernel: [8614238.698703] smpboot: Booting Node 0 Processor 3 APIC 0x5
Aug  5 16:07:46 Joanie kernel: [8614238.701219]  cache: parent cpu3 should not be sleeping
Aug  5 16:07:46 Joanie kernel: [8614238.701456] CPU3 is up
Aug  5 16:07:46 Joanie kernel: [8614238.704053] ACPI: Waking up from system sleep state S3
Aug  5 16:07:46 Joanie kernel: [8614238.886683] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
Aug  5 16:07:46 Joanie kernel: [8614238.886826] ehci-pci 0000:00:1a.0: System wakeup disabled by ACPI
Aug  5 16:07:46 Joanie kernel: [8614238.887005] PM: noirq resume of devices complete after 16.470 msecs
Aug  5 16:07:46 Joanie kernel: [8614238.889163] PM: early resume of devices complete after 2.137 msecs
Aug  5 16:07:46 Joanie kernel: [8614238.889400] r8169 0000:09:00.0: System wakeup disabled by ACPI
Aug  5 16:07:46 Joanie kernel: [8614238.890688] sd 0:0:0:0: [sda] Starting disk
Aug  5 16:07:46 Joanie kernel: [8614238.944043] r8169 0000:09:00.0 enp9s0: link down
Aug  5 16:07:46 Joanie kernel: [8614238.999587] rtc_cmos 00:02: System wakeup disabled by ACPI
Aug  5 16:07:46 Joanie kernel: [8614239.118520] usb 1-1.3: reset full-speed USB device number 3 using ehci-pci
Aug  5 16:07:46 Joanie kernel: [8614239.122458] usb 2-1.4: reset high-speed USB device number 3 using ehci-pci
Aug  5 16:07:46 Joanie kernel: [8614239.206504] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug  5 16:07:46 Joanie kernel: [8614239.206768] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
Aug  5 16:07:46 Joanie kernel: [8614239.206770] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
Aug  5 16:07:46 Joanie kernel: [8614239.207322] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
Aug  5 16:07:46 Joanie kernel: [8614239.207324] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
Aug  5 16:07:46 Joanie kernel: [8614239.207516] ata1.00: configured for UDMA/133
Aug  5 16:07:46 Joanie kernel: [8614239.226504] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Aug  5 16:07:46 Joanie kernel: [8614239.227037] ata2.00: unexpected _GTF length (8)
Aug  5 16:07:46 Joanie kernel: [8614239.228559] ata2.00: unexpected _GTF length (8)
Aug  5 16:07:46 Joanie kernel: [8614239.228563] ata2.00: configured for UDMA/100
Aug  5 16:07:46 Joanie kernel: [8614239.230469] ata6: SATA link down (SStatus 0 SControl 300)
Aug  5 16:07:46 Joanie kernel: [8614239.238503] ata5: SATA link down (SStatus 0 SControl 300)
Aug  5 16:07:46 Joanie kernel: [8614239.286481] usb 2-1.2: reset high-speed USB device number 7 using ehci-pci
Aug  5 16:07:46 Joanie kernel: [8614239.286484] usb 1-1.6: reset full-speed USB device number 5 using ehci-pci
Aug  5 16:07:46 Joanie kernel: [8614239.383900] PM: resume of devices complete after 494.766 msecs
Aug  5 16:07:46 Joanie kernel: [8614239.384750] PM: Finishing wakeup.
Aug  5 16:07:46 Joanie kernel: [8614239.384753] Restarting tasks ... done.
Aug  5 16:07:46 Joanie kernel: [8614239.461301] video LNXVIDEO:01: Restoring backlight state
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.2569] manager: wake requested (sleeping: yes  enabled: yes)
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.2570] manager: waking up...
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.2571] device (enp9s0): state change: unavailable -> unmanaged (reason 'sleeping') [20 10 37]
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.2779] device (wlp3s0): state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
Aug  5 16:07:47 Joanie kernel: [8614239.821618] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
Aug  5 16:07:47 Joanie kernel: [8614239.821843] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  5 16:07:47 Joanie kernel: [8614239.829367] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  5 16:07:47 Joanie kernel: [8614239.829474] iwlwifi 0000:03:00.0: Radio type=0x0-0x0-0x3
Aug  5 16:07:47 Joanie kernel: [8614239.866195] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  5 16:07:47 Joanie kernel: [8614239.873750] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  5 16:07:47 Joanie kernel: [8614239.873851] iwlwifi 0000:03:00.0: Radio type=0x0-0x0-0x3
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.3649] device (enp9s0): state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
Aug  5 16:07:47 Joanie kernel: [8614239.906555] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
Aug  5 16:07:47 Joanie kernel: [8614239.908678] IPv6: ADDRCONF(NETDEV_UP): enp9s0: link is not ready
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.4221] manager: NetworkManager state is now DISCONNECTED
Aug  5 16:07:47 Joanie kernel: [8614239.963795] r8169 0000:09:00.0 enp9s0: link down
Aug  5 16:07:47 Joanie kernel: [8614239.963885] IPv6: ADDRCONF(NETDEV_UP): enp9s0: link is not ready
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.4767] device (wlp3s0): supplicant interface state: starting -> ready
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.4769] device (wlp3s0): state change: unavailable -> disconnected (reason 'supplicant-available') [20 30 42]
Aug  5 16:07:47 Joanie kernel: [8614240.020680] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
Aug  5 16:07:47 Joanie kernel: [8614240.041482] psmouse serio4: synaptics: queried max coordinates: x [..5856], y [..4938]
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.8998] device (wlp3s0): supplicant interface state: ready -> inactive
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.9048] policy: auto-activating connection 'VoicePlex'
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.9061] device (wlp3s0): Activation: starting connection 'VoicePlex' (cf0aa26d-621a-4742-bf42-0b0a1644f3ca)
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.9064] device (wlp3s0): state change: disconnected -> prepare (reason 'none') [30 40 0]
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.9066] manager: NetworkManager state is now CONNECTING
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.9075] device (wlp3s0): state change: prepare -> config (reason 'none') [40 50 0]
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.9079] device (wlp3s0): Activation: (wifi) access point 'VoicePlex' has security, but secrets are required.
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.9080] device (wlp3s0): state change: config -> need-auth (reason 'none') [50 60 0]
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.9138] device (wlp3s0): state change: need-auth -> prepare (reason 'none') [60 40 0]
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.9147] device (wlp3s0): state change: prepare -> config (reason 'none') [40 50 0]
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.9151] device (wlp3s0): Activation: (wifi) connection 'VoicePlex' has security, and secrets exist.  No new secrets needed.
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.9152] Config: added 'ssid' value 'VoicePlex'
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.9153] Config: added 'scan_ssid' value '1'
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.9153] Config: added 'key_mgmt' value 'WPA-PSK'
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.9153] Config: added 'auth_alg' value 'OPEN'
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.9153] Config: added 'psk' value '<omitted>'
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.9172] sup-iface[0xaa30b0,wlp3s0]: config: set interface ap_scan to 1
Aug  5 16:07:47 Joanie kernel: [8614240.471635] wlp3s0: authenticate with c0:8a:de:20:2f:68
Aug  5 16:07:47 Joanie kernel: [8614240.473161] wlp3s0: send auth to c0:8a:de:20:2f:68 (try 1/3)
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.9339] device (wlp3s0): supplicant interface state: inactive -> associating
Aug  5 16:07:47 Joanie kernel: [8614240.474664] wlp3s0: authenticated
Aug  5 16:07:47 Joanie kernel: [8614240.478342] wlp3s0: associate with c0:8a:de:20:2f:68 (try 1/3)
Aug  5 16:07:47 Joanie kernel: [8614240.483634] wlp3s0: RX AssocResp from c0:8a:de:20:2f:68 (capab=0x431 status=0 aid=1)
Aug  5 16:07:47 Joanie kernel: [8614240.487170] wlp3s0: associated
Aug  5 16:07:47 Joanie kernel: [8614240.487273] IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s0: link becomes ready
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.9501] device (wlp3s0): supplicant interface state: associating -> 4-way handshake
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.9575] device (wlp3s0): supplicant interface state: 4-way handshake -> completed
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.9575] device (wlp3s0): Activation: (wifi) Stage 2 of 5 (Device Configure) successful.  Connected to wireless network 'VoicePlex'.
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.9577] device (wlp3s0): state change: config -> ip-config (reason 'none') [50 70 0]
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.9585] dhcp4 (wlp3s0): activation: beginning transaction (timeout in 45 seconds)
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.9612] dhcp4 (wlp3s0): dhclient started with pid 15810
Aug  5 16:07:48 Joanie NetworkManager[866]: <info>  [1533499668.4152]   address 10.10.10.100
Aug  5 16:07:48 Joanie NetworkManager[866]: <info>  [1533499668.4152]   plen 24 (255.255.255.0)
Aug  5 16:07:48 Joanie NetworkManager[866]: <info>  [1533499668.4153]   gateway 10.10.10.254
Aug  5 16:07:48 Joanie NetworkManager[866]: <info>  [1533499668.4153]   server identifier 10.10.10.254
Aug  5 16:07:48 Joanie NetworkManager[866]: <info>  [1533499668.4153]   lease time 86400
Aug  5 16:07:48 Joanie NetworkManager[866]: <info>  [1533499668.4153]   hostname 'Joanie'
Aug  5 16:07:48 Joanie NetworkManager[866]: <info>  [1533499668.4154]   nameserver '10.10.10.254'
Aug  5 16:07:48 Joanie NetworkManager[866]: <info>  [1533499668.4154] dhcp4 (wlp3s0): state changed unknown -> bound
Aug  5 16:07:48 Joanie NetworkManager[866]: <info>  [1533499668.4200] device (wlp3s0): state change: ip-config -> ip-check (reason 'none') [70 80 0]
Aug  5 16:07:48 Joanie NetworkManager[866]: <info>  [1533499668.4239] device (wlp3s0): state change: ip-check -> secondaries (reason 'none') [80 90 0]
Aug  5 16:07:48 Joanie NetworkManager[866]: <info>  [1533499668.4245] device (wlp3s0): state change: secondaries -> activated (reason 'none') [90 100 0]
Aug  5 16:07:48 Joanie NetworkManager[866]: <info>  [1533499668.4247] manager: NetworkManager state is now CONNECTED_LOCAL
Aug  5 16:07:48 Joanie NetworkManager[866]: <info>  [1533499668.4332] manager: NetworkManager state is now CONNECTED_GLOBAL
Aug  5 16:07:48 Joanie NetworkManager[866]: <info>  [1533499668.4334] policy: set 'VoicePlex' (wlp3s0) as default for IPv4 routing and DNS
Aug  5 16:07:48 Joanie NetworkManager[866]: <info>  [1533499668.4336] dns-mgr: Writing DNS information to /sbin/resolvconf
Aug  5 16:07:48 Joanie NetworkManager[866]: <info>  [1533499668.4482] device (wlp3s0): Activation: successful, device activated.
Aug  5 16:09:44 Joanie NetworkManager[866]: <info>  [1533499784.3229] manager: sleep requested (sleeping: no  enabled: yes)
Aug  5 16:09:44 Joanie NetworkManager[866]: <info>  [1533499784.3230] manager: sleeping...
Aug  5 16:09:44 Joanie NetworkManager[866]: <info>  [1533499784.3231] device (wlp3s0): state change: activated -> unmanaged (reason 'sleeping') [100 10 37]
Aug  5 16:09:44 Joanie NetworkManager[866]: <info>  [1533499784.3400] dhcp4 (wlp3s0): canceled DHCP transaction, DHCP client pid 15810
Aug  5 16:09:44 Joanie NetworkManager[866]: <info>  [1533499784.3401] dhcp4 (wlp3s0): state changed bound -> done
Aug  5 16:09:44 Joanie kernel: [8614356.876899] wlp3s0: deauthenticating from c0:8a:de:20:2f:68 by local choice (Reason: 3=DEAUTH_LEAVING)
Aug  5 16:09:44 Joanie NetworkManager[866]: <info>  [1533499784.3538] dns-mgr: Writing DNS information to /sbin/resolvconf
Aug  5 16:09:44 Joanie kernel: [8614356.895286] cfg80211: World regulatory domain updated:
Aug  5 16:09:44 Joanie kernel: [8614356.895292] cfg80211:  DFS Master region: unset
Aug  5 16:09:44 Joanie kernel: [8614356.895295] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
Aug  5 16:09:44 Joanie kernel: [8614356.895299] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
Aug  5 16:09:44 Joanie kernel: [8614356.895303] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
Aug  5 16:09:44 Joanie kernel: [8614356.895307] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
Aug  5 16:09:44 Joanie kernel: [8614356.895311] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (N/A)
Aug  5 16:09:44 Joanie kernel: [8614356.895315] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (0 s)
Aug  5 16:09:44 Joanie kernel: [8614356.895318] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
Aug  5 16:09:44 Joanie kernel: [8614356.895322] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
Aug  5 16:09:44 Joanie kernel: [8614356.895326] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
Aug  5 16:09:44 Joanie NetworkManager[866]: <info>  [1533499784.3692] manager: NetworkManager state is now ASLEEP
Aug  5 19:22:06 Joanie kernel: [8614366.955310] PM: Syncing filesystems ... done.
Aug  5 19:22:06 Joanie kernel: [8614366.970048] PM: Preparing system for sleep (mem)
Aug  5 19:22:06 Joanie kernel: [8614366.970410] Freezing user space processes ... (elapsed 0.002 seconds) done.
Aug  5 19:22:06 Joanie kernel: [8614366.972588] Freezing remaining freezable tasks ... (elapsed 0.048 seconds) done.
Aug  5 19:22:06 Joanie kernel: [8614367.021487] PM: Suspending system (mem)
Aug  5 19:22:06 Joanie kernel: [8614367.021569] Suspending console(s) (use no_console_suspend to debug)
Aug  5 19:22:06 Joanie kernel: [8614367.176377] sd 0:0:0:0: [sda] Synchronizing SCSI cache
Aug  5 19:22:06 Joanie kernel: [8614367.177209] sd 0:0:0:0: [sda] Stopping disk
Aug  5 19:22:06 Joanie kernel: [8614367.464398] PM: suspend of devices complete after 442.634 msecs
Aug  5 19:22:06 Joanie kernel: [8614367.478139] PM: late suspend of devices complete after 13.737 msecs
Aug  5 19:22:06 Joanie kernel: [8614367.479236] r8169 0000:09:00.0: System wakeup enabled by ACPI
Aug  5 19:22:06 Joanie kernel: [8614367.479524] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
Aug  5 19:22:06 Joanie kernel: [8614367.479775] ehci-pci 0000:00:1a.0: System wakeup enabled by ACPI
Aug  5 19:22:06 Joanie kernel: [8614367.494181] PM: noirq suspend of devices complete after 16.038 msecs
Aug  5 19:22:06 Joanie kernel: [8614367.494354] ACPI: Preparing to enter system sleep state S3
Aug  5 19:22:06 Joanie kernel: [8614367.678300] ACPI : EC: EC stopped
Aug  5 19:22:06 Joanie kernel: [8614367.678301] PM: Saving platform NVS memory
Aug  5 19:22:06 Joanie kernel: [8614367.679270] Disabling non-boot CPUs ...
Aug  5 19:22:06 Joanie kernel: [8614367.680732] smpboot: CPU 1 is now offline
Aug  5 19:22:06 Joanie kernel: [8614367.691038] Broke affinity for irq 16
Aug  5 19:22:06 Joanie kernel: [8614367.691050] Broke affinity for irq 23
Aug  5 19:22:06 Joanie kernel: [8614367.691056] Broke affinity for irq 26
Aug  5 19:22:06 Joanie kernel: [8614367.692103] smpboot: CPU 2 is now offline
Aug  5 19:22:06 Joanie kernel: [8614367.702981] Broke affinity for irq 1
Aug  5 19:22:06 Joanie kernel: [8614367.702991] Broke affinity for irq 9
Aug  5 19:22:06 Joanie kernel: [8614367.702997] Broke affinity for irq 12
Aug  5 19:22:06 Joanie kernel: [8614367.703003] Broke affinity for irq 16
Aug  5 19:22:06 Joanie kernel: [8614367.703014] Broke affinity for irq 23
Aug  5 19:22:06 Joanie kernel: [8614367.703018] Broke affinity for irq 24
Aug  5 19:22:06 Joanie kernel: [8614367.703020] Broke affinity for irq 25
Aug  5 19:22:06 Joanie kernel: [8614367.703022] Broke affinity for irq 26
Aug  5 19:22:06 Joanie kernel: [8614367.703024] Broke affinity for irq 29
Aug  5 19:22:06 Joanie kernel: [8614367.704056] smpboot: CPU 3 is now offline
Aug  5 19:22:06 Joanie kernel: [8614367.715519] ACPI: Low-level resume complete
Aug  5 19:22:06 Joanie kernel: [8614367.715579] ACPI : EC: EC started
Aug  5 19:22:06 Joanie kernel: [8614367.715580] PM: Restoring platform NVS memory
Aug  5 19:22:06 Joanie kernel: [8614367.716147] Enabling non-boot CPUs ...
Aug  5 19:22:06 Joanie kernel: [8614367.735551] x86: Booting SMP configuration:
Aug  5 19:22:06 Joanie kernel: [8614367.735552] smpboot: Booting Node 0 Processor 1 APIC 0x4
Aug  5 19:22:06 Joanie kernel: [8614367.738162]  cache: parent cpu1 should not be sleeping
Aug  5 19:22:06 Joanie kernel: [8614367.738404] CPU1 is up
Aug  5 19:22:06 Joanie kernel: [8614367.755570] smpboot: Booting Node 0 Processor 2 APIC 0x1
Aug  5 19:22:06 Joanie kernel: [8614367.758065]  cache: parent cpu2 should not be sleeping
Aug  5 19:22:06 Joanie kernel: [8614367.758308] CPU2 is up
Aug  5 19:22:06 Joanie kernel: [8614367.771618] smpboot: Booting Node 0 Processor 3 APIC 0x5
Aug  5 19:22:06 Joanie kernel: [8614367.774134]  cache: parent cpu3 should not be sleeping
Aug  5 19:22:06 Joanie kernel: [8614367.774375] CPU3 is up
Aug  5 19:22:06 Joanie kernel: [8614367.776970] ACPI: Waking up from system sleep state S3
Aug  5 19:22:06 Joanie kernel: [8614367.959562] ehci-pci 0000:00:1a.0: System wakeup disabled by ACPI
Aug  5 19:22:06 Joanie kernel: [8614367.959596] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
Aug  5 19:22:06 Joanie kernel: [8614367.959940] PM: noirq resume of devices complete after 16.488 msecs
Aug  5 19:22:06 Joanie kernel: [8614367.962042] PM: early resume of devices complete after 2.080 msecs
Aug  5 19:22:06 Joanie kernel: [8614367.962325] r8169 0000:09:00.0: System wakeup disabled by ACPI
Aug  5 19:22:06 Joanie kernel: [8614367.962663] sd 0:0:0:0: [sda] Starting disk
Aug  5 19:22:06 Joanie kernel: [8614368.016888] r8169 0000:09:00.0 enp9s0: link down
Aug  5 19:22:06 Joanie kernel: [8614368.072365] rtc_cmos 00:02: System wakeup disabled by ACPI
Aug  5 19:22:06 Joanie kernel: [8614368.191380] usb 2-1.4: reset high-speed USB device number 3 using ehci-pci
Aug  5 19:22:06 Joanie kernel: [8614368.191397] usb 1-1.3: reset full-speed USB device number 3 using ehci-pci
Aug  5 19:22:06 Joanie kernel: [8614368.291353] ata5: SATA link down (SStatus 0 SControl 300)
Aug  5 19:22:06 Joanie kernel: [8614368.295371] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Aug  5 19:22:06 Joanie kernel: [8614368.295974] ata2.00: unexpected _GTF length (8)
Aug  5 19:22:06 Joanie kernel: [8614368.297449] ata2.00: unexpected _GTF length (8)
Aug  5 19:22:06 Joanie kernel: [8614368.297454] ata2.00: configured for UDMA/100
Aug  5 19:22:06 Joanie kernel: [8614368.303420] ata6: SATA link down (SStatus 0 SControl 300)
Aug  5 19:22:06 Joanie kernel: [8614368.355377] usb 1-1.6: reset full-speed USB device number 5 using ehci-pci
Aug  5 19:22:06 Joanie kernel: [8614368.359414] usb 2-1.2: reset high-speed USB device number 7 using ehci-pci
Aug  5 19:22:06 Joanie kernel: [8614368.456750] PM: resume of devices complete after 494.733 msecs
Aug  5 19:22:06 Joanie kernel: [8614368.457330] PM: Finishing wakeup.
Aug  5 19:22:06 Joanie kernel: [8614368.457331] Restarting tasks ... done.
Aug  5 19:22:06 Joanie kernel: [8614368.530753] video LNXVIDEO:01: Restoring backlight state
Aug  5 19:22:07 Joanie kernel: [8614369.101255] psmouse serio4: synaptics: queried max coordinates: x [..5856], y [..4938]
Aug  5 19:22:07 Joanie kernel: [8614369.191361] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug  5 19:22:07 Joanie kernel: [8614369.192433] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
Aug  5 19:22:07 Joanie kernel: [8614369.192439] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
Aug  5 19:22:07 Joanie kernel: [8614369.194960] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
Aug  5 19:22:07 Joanie kernel: [8614369.194964] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
Aug  5 19:22:07 Joanie kernel: [8614369.195140] ata1.00: configured for UDMA/133
Aug  5 19:22:07 Joanie kernel: [8614369.554881] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
Aug  5 19:22:07 Joanie kernel: [8614369.555090] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  5 19:22:07 Joanie kernel: [8614369.562684] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  5 19:22:07 Joanie kernel: [8614369.562787] iwlwifi 0000:03:00.0: Radio type=0x0-0x0-0x3
Aug  5 19:22:07 Joanie NetworkManager[866]: <info>  [1533511327.9194] manager: wake requested (sleeping: yes  enabled: yes)
Aug  5 19:22:07 Joanie NetworkManager[866]: <info>  [1533511327.9195] manager: waking up...
Aug  5 19:22:07 Joanie NetworkManager[866]: <info>  [1533511327.9196] device (enp9s0): state change: unavailable -> unmanaged (reason 'sleeping') [20 10 37]
Aug  5 19:22:07 Joanie NetworkManager[866]: <info>  [1533511327.9382] device (wlp3s0): state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
Aug  5 19:22:07 Joanie kernel: [8614369.596983] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  5 19:22:07 Joanie kernel: [8614369.604480] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  5 19:22:07 Joanie kernel: [8614369.604580] iwlwifi 0000:03:00.0: Radio type=0x0-0x0-0x3
Aug  5 19:22:08 Joanie kernel: [8614369.637751] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.0230] device (enp9s0): state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
Aug  5 19:22:08 Joanie kernel: [8614369.639790] IPv6: ADDRCONF(NETDEV_UP): enp9s0: link is not ready
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.0824] manager: NetworkManager state is now DISCONNECTED
Aug  5 19:22:08 Joanie kernel: [8614369.696618] r8169 0000:09:00.0 enp9s0: link down
Aug  5 19:22:08 Joanie kernel: [8614369.696704] IPv6: ADDRCONF(NETDEV_UP): enp9s0: link is not ready
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.1405] device (wlp3s0): supplicant interface state: starting -> ready
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.1407] device (wlp3s0): state change: unavailable -> disconnected (reason 'supplicant-available') [20 30 42]
Aug  5 19:22:08 Joanie kernel: [8614369.757164] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.5676] device (wlp3s0): supplicant interface state: ready -> inactive
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.5726] policy: auto-activating connection 'VoicePlex'
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.5743] device (wlp3s0): Activation: starting connection 'VoicePlex' (cf0aa26d-621a-4742-bf42-0b0a1644f3ca)
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.5745] device (wlp3s0): state change: disconnected -> prepare (reason 'none') [30 40 0]
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.5746] manager: NetworkManager state is now CONNECTING
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.5752] device (wlp3s0): state change: prepare -> config (reason 'none') [40 50 0]
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.5755] device (wlp3s0): Activation: (wifi) access point 'VoicePlex' has security, but secrets are required.
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.5755] device (wlp3s0): state change: config -> need-auth (reason 'none') [50 60 0]
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.5802] device (wlp3s0): state change: need-auth -> prepare (reason 'none') [60 40 0]
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.5806] device (wlp3s0): state change: prepare -> config (reason 'none') [40 50 0]
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.5809] device (wlp3s0): Activation: (wifi) connection 'VoicePlex' has security, and secrets exist.  No new secrets needed.
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.5810] Config: added 'ssid' value 'VoicePlex'
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.5811] Config: added 'scan_ssid' value '1'
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.5811] Config: added 'key_mgmt' value 'WPA-PSK'
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.5811] Config: added 'auth_alg' value 'OPEN'
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.5811] Config: added 'psk' value '<omitted>'
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.5836] sup-iface[0xb0f7a0,wlp3s0]: config: set interface ap_scan to 1
Aug  5 19:22:08 Joanie kernel: [8614370.211535] wlp3s0: authenticate with c0:8a:de:20:2f:68
Aug  5 19:22:08 Joanie kernel: [8614370.213147] wlp3s0: send auth to c0:8a:de:20:2f:68 (try 1/3)
Aug  5 19:22:08 Joanie kernel: [8614370.214708] wlp3s0: authenticated
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.6009] device (wlp3s0): supplicant interface state: inactive -> associating
Aug  5 19:22:08 Joanie kernel: [8614370.215395] wlp3s0: associate with c0:8a:de:20:2f:68 (try 1/3)
Aug  5 19:22:08 Joanie kernel: [8614370.219353] wlp3s0: RX AssocResp from c0:8a:de:20:2f:68 (capab=0x431 status=0 aid=5)
Aug  5 19:22:08 Joanie kernel: [8614370.222822] wlp3s0: associated
Aug  5 19:22:08 Joanie kernel: [8614370.222893] IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s0: link becomes ready
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.6153] device (wlp3s0): supplicant interface state: associating -> completed
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.6157] device (wlp3s0): Activation: (wifi) Stage 2 of 5 (Device Configure) successful.  Connected to wireless network 'VoicePlex'.
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.6161] device (wlp3s0): state change: config -> ip-config (reason 'none') [50 70 0]
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.6166] dhcp4 (wlp3s0): activation: beginning transaction (timeout in 45 seconds)
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.6202] dhcp4 (wlp3s0): dhclient started with pid 16178
Aug  5 19:22:09 Joanie NetworkManager[866]: <info>  [1533511329.0639]   address 10.10.10.100
Aug  5 19:22:09 Joanie NetworkManager[866]: <info>  [1533511329.0640]   plen 24 (255.255.255.0)
Aug  5 19:22:09 Joanie NetworkManager[866]: <info>  [1533511329.0640]   gateway 10.10.10.254
Aug  5 19:22:09 Joanie NetworkManager[866]: <info>  [1533511329.0640]   server identifier 10.10.10.254
Aug  5 19:22:09 Joanie NetworkManager[866]: <info>  [1533511329.0641]   lease time 86400
Aug  5 19:22:09 Joanie NetworkManager[866]: <info>  [1533511329.0641]   hostname 'Joanie'
Aug  5 19:22:09 Joanie NetworkManager[866]: <info>  [1533511329.0642]   nameserver '10.10.10.254'
Aug  5 19:22:09 Joanie NetworkManager[866]: <info>  [1533511329.0642] dhcp4 (wlp3s0): state changed unknown -> bound
Aug  5 19:22:09 Joanie NetworkManager[866]: <info>  [1533511329.0704] device (wlp3s0): state change: ip-config -> ip-check (reason 'none') [70 80 0]
Aug  5 19:22:09 Joanie NetworkManager[866]: <info>  [1533511329.0720] device (wlp3s0): state change: ip-check -> secondaries (reason 'none') [80 90 0]
Aug  5 19:22:09 Joanie NetworkManager[866]: <info>  [1533511329.0731] device (wlp3s0): state change: secondaries -> activated (reason 'none') [90 100 0]
Aug  5 19:22:09 Joanie NetworkManager[866]: <info>  [1533511329.0735] manager: NetworkManager state is now CONNECTED_LOCAL
Aug  5 19:22:09 Joanie NetworkManager[866]: <info>  [1533511329.0874] manager: NetworkManager state is now CONNECTED_GLOBAL
Aug  5 19:22:09 Joanie NetworkManager[866]: <info>  [1533511329.0875] policy: set 'VoicePlex' (wlp3s0) as default for IPv4 routing and DNS
Aug  5 19:22:09 Joanie NetworkManager[866]: <info>  [1533511329.0878] dns-mgr: Writing DNS information to /sbin/resolvconf
Aug  5 19:22:09 Joanie NetworkManager[866]: <info>  [1533511329.0983] device (wlp3s0): Activation: successful, device activated.
Aug  5 19:22:14 Joanie kernel: [8614375.842829] usb 1-1.1: new high-speed USB device number 14 using ehci-pci
Aug  5 19:22:14 Joanie kernel: [8614375.941560] usb 1-1.1: New USB device found, idVendor=090c, idProduct=1000
Aug  5 19:22:14 Joanie kernel: [8614375.941570] usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Aug  5 19:22:14 Joanie kernel: [8614375.941575] usb 1-1.1: Product: Flash Drive
Aug  5 19:22:14 Joanie kernel: [8614375.941580] usb 1-1.1: Manufacturer: Samsung
Aug  5 19:22:14 Joanie kernel: [8614375.941585] usb 1-1.1: SerialNumber: 0375717070007140
Aug  5 19:22:14 Joanie kernel: [8614375.942994] usb-storage 1-1.1:1.0: USB Mass Storage device detected
Aug  5 19:22:14 Joanie kernel: [8614375.944733] scsi host15: usb-storage 1-1.1:1.0
Aug  5 19:22:15 Joanie kernel: [8614377.164209] scsi 15:0:0:0: Direct-Access     Samsung  Flash Drive      1100 PQ: 0 ANSI: 6
Aug  5 19:22:15 Joanie kernel: [8614377.165297] sd 15:0:0:0: Attached scsi generic sg2 type 0
Aug  5 19:22:15 Joanie kernel: [8614377.166127] sd 15:0:0:0: [sdb] 62668800 512-byte logical blocks: (32.1 GB/29.9 GiB)
Aug  5 19:22:15 Joanie kernel: [8614377.167078] sd 15:0:0:0: [sdb] Write Protect is off
Aug  5 19:22:15 Joanie kernel: [8614377.167083] sd 15:0:0:0: [sdb] Mode Sense: 43 00 00 00
Aug  5 19:22:15 Joanie kernel: [8614377.168212] sd 15:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Aug  5 19:22:15 Joanie kernel: [8614377.178012]  sdb: sdb1
Aug  5 19:22:15 Joanie kernel: [8614377.182497] sd 15:0:0:0: [sdb] Attached SCSI removable disk
Aug  5 19:23:59 Joanie kernel: [8614480.853352] usb 1-1.1: USB disconnect, device number 14
Aug  5 19:34:47 Joanie kernel: [8615129.462201] usb 1-1.1: new high-speed USB device number 15 using ehci-pci
Aug  5 19:34:47 Joanie kernel: [8615129.560856] usb 1-1.1: New USB device found, idVendor=090c, idProduct=1000
Aug  5 19:34:47 Joanie kernel: [8615129.560865] usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Aug  5 19:34:47 Joanie kernel: [8615129.560871] usb 1-1.1: Product: Flash Drive
Aug  5 19:34:47 Joanie kernel: [8615129.560875] usb 1-1.1: Manufacturer: Samsung
Aug  5 19:34:47 Joanie kernel: [8615129.560880] usb 1-1.1: SerialNumber: 0375717070007140
Aug  5 19:34:47 Joanie kernel: [8615129.562296] usb-storage 1-1.1:1.0: USB Mass Storage device detected
Aug  5 19:34:47 Joanie kernel: [8615129.563909] scsi host16: usb-storage 1-1.1:1.0
Aug  5 19:34:49 Joanie kernel: [8615130.782316] scsi 16:0:0:0: Direct-Access     Samsung  Flash Drive      1100 PQ: 0 ANSI: 6
Aug  5 19:34:49 Joanie kernel: [8615130.783245] sd 16:0:0:0: Attached scsi generic sg2 type 0
Aug  5 19:34:49 Joanie kernel: [8615130.784134] sd 16:0:0:0: [sdb] 62668800 512-byte logical blocks: (32.1 GB/29.9 GiB)
Aug  5 19:34:49 Joanie kernel: [8615130.785158] sd 16:0:0:0: [sdb] Write Protect is off
Aug  5 19:34:49 Joanie kernel: [8615130.785171] sd 16:0:0:0: [sdb] Mode Sense: 43 00 00 00
Aug  5 19:34:49 Joanie kernel: [8615130.786306] sd 16:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Aug  5 19:34:49 Joanie kernel: [8615130.793715]  sdb: sdb1
Aug  5 19:34:49 Joanie kernel: [8615130.798440] sd 16:0:0:0: [sdb] Attached SCSI removable disk
Aug  5 19:35:32 Joanie kernel: [8615173.886875] nemo[1907]: segfault at a ip 00007f49ddd099de sp 00007ffdf20412a8 error 4 in libc-2.23.so (deleted)[7f49ddc6b000+1bf000]
Aug  5 19:36:42 Joanie kernel: [8615244.199824] usb 1-1.1: USB disconnect, device number 15
Aug  5 19:37:57 Joanie NetworkManager[866]: <info>  [1533512277.5216] manager: sleep requested (sleeping: no  enabled: yes)
Aug  5 19:37:57 Joanie NetworkManager[866]: <info>  [1533512277.5216] manager: sleeping...
Aug  5 19:37:57 Joanie NetworkManager[866]: <info>  [1533512277.5217] device (wlp3s0): state change: activated -> unmanaged (reason 'sleeping') [100 10 37]
Aug  5 19:37:57 Joanie NetworkManager[866]: <info>  [1533512277.5549] dhcp4 (wlp3s0): canceled DHCP transaction, DHCP client pid 16178
Aug  5 19:37:57 Joanie NetworkManager[866]: <info>  [1533512277.5550] dhcp4 (wlp3s0): state changed bound -> done
Aug  5 19:37:57 Joanie NetworkManager[866]: <info>  [1533512277.5582] dns-mgr: Writing DNS information to /sbin/resolvconf
Aug  5 19:37:57 Joanie kernel: [8615319.113615] wlp3s0: deauthenticating from c0:8a:de:20:2f:68 by local choice (Reason: 3=DEAUTH_LEAVING)
Aug  5 19:37:57 Joanie kernel: [8615319.127417] cfg80211: World regulatory domain updated:
Aug  5 19:37:57 Joanie kernel: [8615319.127422] cfg80211:  DFS Master region: unset
Aug  5 19:37:57 Joanie kernel: [8615319.127424] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
Aug  5 19:37:57 Joanie kernel: [8615319.127428] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
Aug  5 19:37:57 Joanie kernel: [8615319.127430] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
Aug  5 19:37:57 Joanie kernel: [8615319.127432] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
Aug  5 19:37:57 Joanie kernel: [8615319.127435] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (N/A)
Aug  5 19:37:57 Joanie kernel: [8615319.127438] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (0 s)
Aug  5 19:37:57 Joanie kernel: [8615319.127440] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
Aug  5 19:37:57 Joanie kernel: [8615319.127443] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
Aug  5 19:37:57 Joanie kernel: [8615319.127445] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
Aug  5 19:37:57 Joanie NetworkManager[866]: <info>  [1533512277.5828] manager: NetworkManager state is now ASLEEP
Aug  7 22:04:21 Joanie kernel: [8615329.187302] PM: Syncing filesystems ... done.
Aug  7 22:04:21 Joanie kernel: [8615329.202911] PM: Preparing system for sleep (mem)
Aug  7 22:04:21 Joanie kernel: [8615329.203231] Freezing user space processes ... (elapsed 0.002 seconds) done.
Aug  7 22:04:21 Joanie kernel: [8615329.205413] Freezing remaining freezable tasks ... (elapsed 0.077 seconds) done.
Aug  7 22:04:21 Joanie kernel: [8615329.282787] PM: Suspending system (mem)
Aug  7 22:04:21 Joanie kernel: [8615329.282870] Suspending console(s) (use no_console_suspend to debug)
Aug  7 22:04:21 Joanie kernel: [8615329.441006] sd 0:0:0:0: [sda] Synchronizing SCSI cache
Aug  7 22:04:21 Joanie kernel: [8615329.441853] sd 0:0:0:0: [sda] Stopping disk
Aug  7 22:04:21 Joanie kernel: [8615329.720286] PM: suspend of devices complete after 437.221 msecs
Aug  7 22:04:21 Joanie kernel: [8615329.733391] PM: late suspend of devices complete after 13.101 msecs
Aug  7 22:04:21 Joanie kernel: [8615329.734814] r8169 0000:09:00.0: System wakeup enabled by ACPI
Aug  7 22:04:21 Joanie kernel: [8615329.734892] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
Aug  7 22:04:21 Joanie kernel: [8615329.735164] ehci-pci 0000:00:1a.0: System wakeup enabled by ACPI
Aug  7 22:04:21 Joanie kernel: [8615329.749424] PM: noirq suspend of devices complete after 16.029 msecs
Aug  7 22:04:21 Joanie kernel: [8615329.749589] ACPI: Preparing to enter system sleep state S3
Aug  7 22:04:21 Joanie kernel: [8615329.929543] ACPI : EC: EC stopped
Aug  7 22:04:21 Joanie kernel: [8615329.929544] PM: Saving platform NVS memory
Aug  7 22:04:21 Joanie kernel: [8615329.930434] Disabling non-boot CPUs ...
Aug  7 22:04:21 Joanie kernel: [8615329.931867] smpboot: CPU 1 is now offline
Aug  7 22:04:21 Joanie kernel: [8615329.942216] Broke affinity for irq 16
Aug  7 22:04:21 Joanie kernel: [8615329.942227] Broke affinity for irq 23
Aug  7 22:04:21 Joanie kernel: [8615329.942231] Broke affinity for irq 25
Aug  7 22:04:21 Joanie kernel: [8615329.943276] smpboot: CPU 2 is now offline
Aug  7 22:04:21 Joanie kernel: [8615329.954304] Broke affinity for irq 1
Aug  7 22:04:21 Joanie kernel: [8615329.954314] Broke affinity for irq 9
Aug  7 22:04:21 Joanie kernel: [8615329.954321] Broke affinity for irq 12
Aug  7 22:04:21 Joanie kernel: [8615329.954327] Broke affinity for irq 16
Aug  7 22:04:21 Joanie kernel: [8615329.954338] Broke affinity for irq 23
Aug  7 22:04:21 Joanie kernel: [8615329.954342] Broke affinity for irq 24
Aug  7 22:04:21 Joanie kernel: [8615329.954344] Broke affinity for irq 25
Aug  7 22:04:21 Joanie kernel: [8615329.954347] Broke affinity for irq 26
Aug  7 22:04:21 Joanie kernel: [8615329.954349] Broke affinity for irq 29
Aug  7 22:04:21 Joanie kernel: [8615329.955397] smpboot: CPU 3 is now offline
Aug  7 22:04:21 Joanie kernel: [8615329.970836] ACPI: Low-level resume complete
Aug  7 22:04:21 Joanie kernel: [8615329.970896] ACPI : EC: EC started
Aug  7 22:04:21 Joanie kernel: [8615329.970897] PM: Restoring platform NVS memory
Aug  7 22:04:21 Joanie kernel: [8615329.971462] Enabling non-boot CPUs ...
Aug  7 22:04:21 Joanie kernel: [8615329.990823] x86: Booting SMP configuration:
Aug  7 22:04:21 Joanie kernel: [8615329.990823] smpboot: Booting Node 0 Processor 1 APIC 0x4
Aug  7 22:04:21 Joanie kernel: [8615329.993430]  cache: parent cpu1 should not be sleeping
Aug  7 22:04:21 Joanie kernel: [8615329.993671] CPU1 is up
Aug  7 22:04:21 Joanie kernel: [8615330.010850] smpboot: Booting Node 0 Processor 2 APIC 0x1
Aug  7 22:04:21 Joanie kernel: [8615330.013333]  cache: parent cpu2 should not be sleeping
Aug  7 22:04:21 Joanie kernel: [8615330.013573] CPU2 is up
Aug  7 22:04:21 Joanie kernel: [8615330.030886] smpboot: Booting Node 0 Processor 3 APIC 0x5
Aug  7 22:04:21 Joanie kernel: [8615330.033403]  cache: parent cpu3 should not be sleeping
Aug  7 22:04:21 Joanie kernel: [8615330.033646] CPU3 is up
Aug  7 22:04:21 Joanie kernel: [8615330.036232] ACPI: Waking up from system sleep state S3
Aug  7 22:04:21 Joanie kernel: [8615330.223100] ehci-pci 0000:00:1a.0: System wakeup disabled by ACPI
Aug  7 22:04:21 Joanie kernel: [8615330.223174] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
Aug  7 22:04:21 Joanie kernel: [8615330.223330] PM: noirq resume of devices complete after 16.601 msecs
Aug  7 22:04:21 Joanie kernel: [8615330.225461] PM: early resume of devices complete after 2.108 msecs
Aug  7 22:04:21 Joanie kernel: [8615330.225739] r8169 0000:09:00.0: System wakeup disabled by ACPI
Aug  7 22:04:21 Joanie kernel: [8615330.226920] sd 0:0:0:0: [sda] Starting disk
Aug  7 22:04:21 Joanie kernel: [8615330.280161] r8169 0000:09:00.0 enp9s0: link down
Aug  7 22:04:21 Joanie kernel: [8615330.335527] rtc_cmos 00:02: System wakeup disabled by ACPI
Aug  7 22:04:21 Joanie kernel: [8615330.454703] usb 1-1.3: reset full-speed USB device number 3 using ehci-pci
Aug  7 22:04:21 Joanie kernel: [8615330.458639] usb 2-1.4: reset high-speed USB device number 3 using ehci-pci
Aug  7 22:04:21 Joanie kernel: [8615330.546671] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug  7 22:04:21 Joanie kernel: [8615330.546953] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
Aug  7 22:04:21 Joanie kernel: [8615330.546955] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
Aug  7 22:04:21 Joanie kernel: [8615330.547563] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
Aug  7 22:04:21 Joanie kernel: [8615330.547568] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
Aug  7 22:04:21 Joanie kernel: [8615330.547715] ata1.00: configured for UDMA/133
Aug  7 22:04:21 Joanie kernel: [8615330.554651] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Aug  7 22:04:21 Joanie kernel: [8615330.555248] ata2.00: unexpected _GTF length (8)
Aug  7 22:04:21 Joanie kernel: [8615330.556729] ata2.00: unexpected _GTF length (8)
Aug  7 22:04:21 Joanie kernel: [8615330.556733] ata2.00: configured for UDMA/100
Aug  7 22:04:21 Joanie kernel: [8615330.562665] ata5: SATA link down (SStatus 0 SControl 300)
Aug  7 22:04:21 Joanie kernel: [8615330.570690] ata6: SATA link down (SStatus 0 SControl 300)
Aug  7 22:04:21 Joanie kernel: [8615330.618653] usb 1-1.6: reset full-speed USB device number 5 using ehci-pci
Aug  7 22:04:21 Joanie kernel: [8615330.622648] usb 2-1.2: reset high-speed USB device number 7 using ehci-pci
Aug  7 22:04:21 Joanie kernel: [8615330.720011] PM: resume of devices complete after 494.574 msecs
Aug  7 22:04:21 Joanie kernel: [8615330.720749] PM: Finishing wakeup.
Aug  7 22:04:21 Joanie kernel: [8615330.720750] Restarting tasks ... done.
Aug  7 22:04:21 Joanie kernel: [8615330.788852] video LNXVIDEO:01: Restoring backlight state
Aug  7 22:04:22 Joanie kernel: [8615331.157412] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
Aug  7 22:04:22 Joanie kernel: [8615331.158662] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.2646] manager: wake requested (sleeping: yes  enabled: yes)
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.2647] manager: waking up...
Aug  7 22:04:22 Joanie kernel: [8615331.166340] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  7 22:04:22 Joanie kernel: [8615331.166442] iwlwifi 0000:03:00.0: Radio type=0x0-0x0-0x3
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.2648] device (enp9s0): state change: unavailable -> unmanaged (reason 'sleeping') [20 10 37]
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.2856] device (wlp3s0): state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
Aug  7 22:04:22 Joanie kernel: [8615331.205759] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  7 22:04:22 Joanie kernel: [8615331.213261] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  7 22:04:22 Joanie kernel: [8615331.213361] iwlwifi 0000:03:00.0: Radio type=0x0-0x0-0x3
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.3819] device (enp9s0): state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
Aug  7 22:04:22 Joanie kernel: [8615331.251722] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
Aug  7 22:04:22 Joanie kernel: [8615331.254070] IPv6: ADDRCONF(NETDEV_UP): enp9s0: link is not ready
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.4373] manager: NetworkManager state is now DISCONNECTED
Aug  7 22:04:22 Joanie kernel: [8615331.307872] r8169 0000:09:00.0 enp9s0: link down
Aug  7 22:04:22 Joanie kernel: [8615331.307939] IPv6: ADDRCONF(NETDEV_UP): enp9s0: link is not ready
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.4936] device (wlp3s0): supplicant interface state: starting -> ready
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.4937] device (wlp3s0): state change: unavailable -> disconnected (reason 'supplicant-available') [20 30 42]
Aug  7 22:04:22 Joanie kernel: [8615331.365575] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
Aug  7 22:04:22 Joanie kernel: [8615331.379565] psmouse serio4: synaptics: queried max coordinates: x [..5856], y [..4938]
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.9592] device (wlp3s0): supplicant interface state: ready -> inactive
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.9649] policy: auto-activating connection 'VoicePlex'
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.9664] device (wlp3s0): Activation: starting connection 'VoicePlex' (cf0aa26d-621a-4742-bf42-0b0a1644f3ca)
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.9669] device (wlp3s0): state change: disconnected -> prepare (reason 'none') [30 40 0]
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.9673] manager: NetworkManager state is now CONNECTING
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.9683] device (wlp3s0): state change: prepare -> config (reason 'none') [40 50 0]
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.9688] device (wlp3s0): Activation: (wifi) access point 'VoicePlex' has security, but secrets are required.
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.9688] device (wlp3s0): state change: config -> need-auth (reason 'none') [50 60 0]
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.9741] device (wlp3s0): state change: need-auth -> prepare (reason 'none') [60 40 0]
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.9747] device (wlp3s0): state change: prepare -> config (reason 'none') [40 50 0]
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.9750] device (wlp3s0): Activation: (wifi) connection 'VoicePlex' has security, and secrets exist.  No new secrets needed.
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.9751] Config: added 'ssid' value 'VoicePlex'
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.9752] Config: added 'scan_ssid' value '1'
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.9752] Config: added 'key_mgmt' value 'WPA-PSK'
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.9752] Config: added 'auth_alg' value 'OPEN'
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.9752] Config: added 'psk' value '<omitted>'
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.9786] sup-iface[0xa9d790,wlp3s0]: config: set interface ap_scan to 1
Aug  7 22:04:22 Joanie kernel: [8615331.863820] wlp3s0: authenticate with c0:8a:de:20:2f:68
Aug  7 22:04:22 Joanie kernel: [8615331.865403] wlp3s0: send auth to c0:8a:de:20:2f:68 (try 1/3)
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.9982] device (wlp3s0): supplicant interface state: inactive -> associating
Aug  7 22:04:22 Joanie kernel: [8615331.866932] wlp3s0: authenticated
Aug  7 22:04:22 Joanie kernel: [8615331.870508] wlp3s0: associate with c0:8a:de:20:2f:68 (try 1/3)
Aug  7 22:04:23 Joanie kernel: [8615331.874535] wlp3s0: RX AssocResp from c0:8a:de:20:2f:68 (capab=0x431 status=0 aid=1)
Aug  7 22:04:23 Joanie kernel: [8615331.877965] wlp3s0: associated
Aug  7 22:04:23 Joanie kernel: [8615331.878039] IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s0: link becomes ready
Aug  7 22:04:23 Joanie NetworkManager[866]: <info>  [1533693863.0151] device (wlp3s0): supplicant interface state: associating -> completed
Aug  7 22:04:23 Joanie NetworkManager[866]: <info>  [1533693863.0152] device (wlp3s0): Activation: (wifi) Stage 2 of 5 (Device Configure) successful.  Connected to wireless network 'VoicePlex'.
Aug  7 22:04:23 Joanie NetworkManager[866]: <info>  [1533693863.0154] device (wlp3s0): state change: config -> ip-config (reason 'none') [50 70 0]
Aug  7 22:04:23 Joanie NetworkManager[866]: <info>  [1533693863.0160] dhcp4 (wlp3s0): activation: beginning transaction (timeout in 45 seconds)
Aug  7 22:04:23 Joanie NetworkManager[866]: <info>  [1533693863.0189] dhcp4 (wlp3s0): dhclient started with pid 17739
Aug  7 22:04:23 Joanie NetworkManager[866]: <info>  [1533693863.4858]   address 10.10.10.100
Aug  7 22:04:23 Joanie NetworkManager[866]: <info>  [1533693863.4859]   plen 24 (255.255.255.0)
Aug  7 22:04:23 Joanie NetworkManager[866]: <info>  [1533693863.4859]   gateway 10.10.10.254
Aug  7 22:04:23 Joanie NetworkManager[866]: <info>  [1533693863.4859]   server identifier 10.10.10.254
Aug  7 22:04:23 Joanie NetworkManager[866]: <info>  [1533693863.4859]   lease time 86400
Aug  7 22:04:23 Joanie NetworkManager[866]: <info>  [1533693863.4860]   hostname 'Joanie'
Aug  7 22:04:23 Joanie NetworkManager[866]: <info>  [1533693863.4860]   nameserver '10.10.10.254'
Aug  7 22:04:23 Joanie NetworkManager[866]: <info>  [1533693863.4860] dhcp4 (wlp3s0): state changed unknown -> bound
Aug  7 22:04:23 Joanie NetworkManager[866]: <info>  [1533693863.4891] device (wlp3s0): state change: ip-config -> ip-check (reason 'none') [70 80 0]
Aug  7 22:04:23 Joanie NetworkManager[866]: <info>  [1533693863.4900] device (wlp3s0): state change: ip-check -> secondaries (reason 'none') [80 90 0]
Aug  7 22:04:23 Joanie NetworkManager[866]: <info>  [1533693863.4906] device (wlp3s0): state change: secondaries -> activated (reason 'none') [90 100 0]
Aug  7 22:04:23 Joanie NetworkManager[866]: <info>  [1533693863.4909] manager: NetworkManager state is now CONNECTED_LOCAL
Aug  7 22:04:23 Joanie NetworkManager[866]: <info>  [1533693863.5024] manager: NetworkManager state is now CONNECTED_GLOBAL
Aug  7 22:04:23 Joanie NetworkManager[866]: <info>  [1533693863.5026] policy: set 'VoicePlex' (wlp3s0) as default for IPv4 routing and DNS
Aug  7 22:04:23 Joanie NetworkManager[866]: <info>  [1533693863.5028] dns-mgr: Writing DNS information to /sbin/resolvconf
Aug  7 22:04:23 Joanie NetworkManager[866]: <info>  [1533693863.5129] device (wlp3s0): Activation: successful, device activated.
Aug  7 22:04:38 Joanie kernel: [8615347.321596] usb 1-1.1: new high-speed USB device number 16 using ehci-pci
Aug  7 22:04:38 Joanie kernel: [8615347.420262] usb 1-1.1: New USB device found, idVendor=090c, idProduct=1000
Aug  7 22:04:38 Joanie kernel: [8615347.420271] usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Aug  7 22:04:38 Joanie kernel: [8615347.420276] usb 1-1.1: Product: Flash Drive
Aug  7 22:04:38 Joanie kernel: [8615347.420281] usb 1-1.1: Manufacturer: Samsung
Aug  7 22:04:38 Joanie kernel: [8615347.420286] usb 1-1.1: SerialNumber: 0375717070007140
Aug  7 22:04:38 Joanie kernel: [8615347.421628] usb-storage 1-1.1:1.0: USB Mass Storage device detected
Aug  7 22:04:38 Joanie kernel: [8615347.422626] scsi host17: usb-storage 1-1.1:1.0
Aug  7 22:04:39 Joanie kernel: [8615348.641649] scsi 17:0:0:0: Direct-Access     Samsung  Flash Drive      1100 PQ: 0 ANSI: 6
Aug  7 22:04:39 Joanie kernel: [8615348.642455] sd 17:0:0:0: Attached scsi generic sg2 type 0
Aug  7 22:04:39 Joanie kernel: [8615348.643301] sd 17:0:0:0: [sdb] 62668800 512-byte logical blocks: (32.1 GB/29.9 GiB)
Aug  7 22:04:39 Joanie kernel: [8615348.644314] sd 17:0:0:0: [sdb] Write Protect is off
Aug  7 22:04:39 Joanie kernel: [8615348.644325] sd 17:0:0:0: [sdb] Mode Sense: 43 00 00 00
Aug  7 22:04:39 Joanie kernel: [8615348.645492] sd 17:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Aug  7 22:04:39 Joanie kernel: [8615348.654238]  sdb: sdb1
Aug  7 22:04:39 Joanie kernel: [8615348.658970] sd 17:0:0:0: [sdb] Attached SCSI removable disk
Aug  7 22:14:10 Joanie kernel: [8615919.504367] usb 1-1.1: USB disconnect, device number 16
Aug  7 22:20:22 Joanie kernel: [8616291.135192] usb 1-1.1: new high-speed USB device number 17 using ehci-pci
Aug  7 22:20:22 Joanie kernel: [8616291.238279] usb 1-1.1: New USB device found, idVendor=090c, idProduct=1000
Aug  7 22:20:22 Joanie kernel: [8616291.238292] usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Aug  7 22:20:22 Joanie kernel: [8616291.238296] usb 1-1.1: Product: Flash Drive
Aug  7 22:20:22 Joanie kernel: [8616291.238299] usb 1-1.1: Manufacturer: Samsung
Aug  7 22:20:22 Joanie kernel: [8616291.238303] usb 1-1.1: SerialNumber: 0375717070007140
Aug  7 22:20:22 Joanie kernel: [8616291.239483] usb-storage 1-1.1:1.0: USB Mass Storage device detected
Aug  7 22:20:22 Joanie kernel: [8616291.240188] scsi host18: usb-storage 1-1.1:1.0
Aug  7 22:20:23 Joanie kernel: [8616292.459706] scsi 18:0:0:0: Direct-Access     Samsung  Flash Drive      1100 PQ: 0 ANSI: 6
Aug  7 22:20:23 Joanie kernel: [8616292.460558] sd 18:0:0:0: Attached scsi generic sg2 type 0
Aug  7 22:20:23 Joanie kernel: [8616292.461490] sd 18:0:0:0: [sdb] 62668800 512-byte logical blocks: (32.1 GB/29.9 GiB)
Aug  7 22:20:23 Joanie kernel: [8616292.462628] sd 18:0:0:0: [sdb] Write Protect is off
Aug  7 22:20:23 Joanie kernel: [8616292.462637] sd 18:0:0:0: [sdb] Mode Sense: 43 00 00 00
Aug  7 22:20:23 Joanie kernel: [8616292.465337] sd 18:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Aug  7 22:20:23 Joanie kernel: [8616292.472388]  sdb: sdb1
Aug  7 22:20:23 Joanie kernel: [8616292.477381] sd 18:0:0:0: [sdb] Attached SCSI removable disk

--Apple-Mail=_05342D18-2BFB-4528-B1B0-59A5380BD521
Content-Disposition: attachment;
	filename=syslog
Content-Type: application/octet-stream;
	x-unix-mode=0777;
	name="syslog"
Content-Transfer-Encoding: 7bit

Jul 17 17:27:15 Joanie colord[959]: (colord:959): Cd-WARNING **: failed to get session [pid 6407]: No such device or address
Jul 17 17:27:15 Joanie anacron[5752]: Job `cron.daily' terminated
Jul 17 17:28:20 Joanie ntpd[14595]: 184.105.182.15 local addr 10.10.10.100 -> <null>
Jul 17 17:32:29 Joanie anacron[5752]: Job `cron.weekly' started
Jul 17 17:32:29 Joanie anacron[6615]: Updated timestamp for job `cron.weekly' to 2018-07-17
Jul 17 17:33:30 Joanie anacron[5752]: Job `cron.weekly' terminated
Jul 17 17:33:30 Joanie anacron[5752]: Normal exit (2 jobs run)
Jul 17 17:39:38 Joanie dbus[850]: [system] Activating via systemd: service name='org.freedesktop.PackageKit' unit='packagekit.service'
Jul 17 17:39:38 Joanie systemd[1]: Starting PackageKit Daemon...
Jul 17 17:39:38 Joanie PackageKit: daemon start
Jul 17 17:39:39 Joanie dbus[850]: [system] Successfully activated service 'org.freedesktop.PackageKit'
Jul 17 17:39:39 Joanie systemd[1]: Started PackageKit Daemon.
Jul 17 17:44:44 Joanie PackageKit: daemon quit
Jul 17 17:44:44 Joanie packagekitd[7024]: (packagekitd:7024): GLib-CRITICAL **: Source ID 9 was not found when attempting to remove it
Jul 17 17:46:54 Joanie ntpd[14595]: 108.59.2.24 local addr 10.10.10.100 -> <null>
Jul 17 18:04:39 Joanie ntpd[14595]: 66.135.44.92 local addr 10.10.10.100 -> <null>
Jul 17 18:07:28 Joanie org.gtk.vfs.Daemon[1873]: ** (process:3196): WARNING **: Couldn't create directory monitor on smb://x-gnome-default-workgroup/. Error: Operation not supported by backend
Jul 17 18:09:37 Joanie dbus[850]: [system] Activating via systemd: service name='org.freedesktop.PackageKit' unit='packagekit.service'
Jul 17 18:09:37 Joanie systemd[1]: Starting PackageKit Daemon...
Jul 17 18:09:37 Joanie PackageKit: daemon start
Jul 17 18:09:37 Joanie dbus[850]: [system] Successfully activated service 'org.freedesktop.PackageKit'
Jul 17 18:09:37 Joanie systemd[1]: Started PackageKit Daemon.
Jul 17 18:14:42 Joanie PackageKit: daemon quit
Jul 17 18:14:42 Joanie packagekitd[7595]: (packagekitd:7595): GLib-CRITICAL **: Source ID 9 was not found when attempting to remove it
Jul 17 18:17:01 Joanie CRON[7656]: (root) CMD (   cd / && run-parts --report /etc/cron.hourly)
Jul 17 18:38:17 Joanie ntpd[14595]: 38.229.71.1 local addr 10.10.10.100 -> <null>
Jul 17 18:38:21 Joanie org.gtk.vfs.Daemon[1873]: ** (process:3196): WARNING **: Couldn't create directory monitor on smb://x-gnome-default-workgroup/. Error: Operation not supported by backend
Jul 17 18:39:37 Joanie dbus[850]: [system] Activating via systemd: service name='org.freedesktop.PackageKit' unit='packagekit.service'
Jul 17 18:39:37 Joanie systemd[1]: Starting PackageKit Daemon...
Jul 17 18:39:37 Joanie PackageKit: daemon start
Jul 17 18:39:37 Joanie dbus[850]: [system] Successfully activated service 'org.freedesktop.PackageKit'
Jul 17 18:39:37 Joanie systemd[1]: Started PackageKit Daemon.
Jul 17 18:44:42 Joanie PackageKit: daemon quit
Jul 17 18:44:42 Joanie packagekitd[8147]: (packagekitd:8147): GLib-CRITICAL **: Source ID 9 was not found when attempting to remove it
Jul 17 18:56:36 Joanie ntpd[14595]: 198.206.133.14 local addr 10.10.10.100 -> <null>
Jul 17 19:09:37 Joanie dbus[850]: [system] Activating via systemd: service name='org.freedesktop.PackageKit' unit='packagekit.service'
Jul 17 19:09:37 Joanie systemd[1]: Starting PackageKit Daemon...
Jul 17 19:09:37 Joanie PackageKit: daemon start
Jul 17 19:09:37 Joanie dbus[850]: [system] Successfully activated service 'org.freedesktop.PackageKit'
Jul 17 19:09:37 Joanie systemd[1]: Started PackageKit Daemon.
Jul 17 19:14:43 Joanie PackageKit: daemon quit
Jul 17 19:14:43 Joanie packagekitd[8686]: (packagekitd:8686): GLib-CRITICAL **: Source ID 9 was not found when attempting to remove it
Jul 17 19:17:01 Joanie CRON[8762]: (root) CMD (   cd / && run-parts --report /etc/cron.hourly)
Jul 17 19:31:01 Joanie org.gtk.vfs.Daemon[1873]: ** (process:3196): WARNING **: Couldn't create directory monitor on smb://x-gnome-default-workgroup/. Error: Operation not supported by backend
Jul 17 19:33:52 Joanie org.gtk.vfs.Daemon[1873]: ** (process:3196): WARNING **: Couldn't create directory monitor on smb://x-gnome-default-workgroup/. Error: Operation not supported by backend
Jul 17 19:39:37 Joanie dbus[850]: [system] Activating via systemd: service name='org.freedesktop.PackageKit' unit='packagekit.service'
Jul 17 19:39:37 Joanie systemd[1]: Starting PackageKit Daemon...
Jul 17 19:39:37 Joanie PackageKit: daemon start
Jul 17 19:39:37 Joanie dbus[850]: [system] Successfully activated service 'org.freedesktop.PackageKit'
Jul 17 19:39:37 Joanie systemd[1]: Started PackageKit Daemon.
Jul 17 19:44:43 Joanie PackageKit: daemon quit
Jul 17 19:44:43 Joanie packagekitd[9241]: (packagekitd:9241): GLib-CRITICAL **: Source ID 9 was not found when attempting to remove it
Jul 17 20:09:37 Joanie dbus[850]: [system] Activating via systemd: service name='org.freedesktop.PackageKit' unit='packagekit.service'
Jul 17 20:09:37 Joanie systemd[1]: Starting PackageKit Daemon...
Jul 17 20:09:37 Joanie PackageKit: daemon start
Jul 17 20:09:37 Joanie dbus[850]: [system] Successfully activated service 'org.freedesktop.PackageKit'
Jul 17 20:09:37 Joanie systemd[1]: Started PackageKit Daemon.
Jul 17 20:14:43 Joanie PackageKit: daemon quit
Jul 17 20:14:43 Joanie packagekitd[9827]: (packagekitd:9827): GLib-CRITICAL **: Source ID 9 was not found when attempting to remove it
Jul 17 20:17:01 Joanie CRON[9882]: (root) CMD (   cd / && run-parts --report /etc/cron.hourly)
Jul 17 20:35:19 Joanie NetworkManager[866]: <info>  [1531874119.8775] manager: sleep requested (sleeping: no  enabled: yes)
Jul 17 20:35:19 Joanie NetworkManager[866]: <info>  [1531874119.8775] manager: sleeping...
Jul 17 20:35:19 Joanie NetworkManager[866]: <info>  [1531874119.8776] device (wlp3s0): state change: activated -> unmanaged (reason 'sleeping') [100 10 37]
Jul 17 20:35:19 Joanie NetworkManager[866]: <info>  [1531874119.9196] dhcp4 (wlp3s0): canceled DHCP transaction, DHCP client pid 5785
Jul 17 20:35:19 Joanie NetworkManager[866]: <info>  [1531874119.9196] dhcp4 (wlp3s0): state changed bound -> done
Jul 17 20:35:19 Joanie avahi-daemon[15386]: Withdrawing address record for 10.10.10.100 on wlp3s0.
Jul 17 20:35:19 Joanie kernel: [8611028.028061] wlp3s0: deauthenticating from c0:8a:de:20:2f:68 by local choice (Reason: 3=DEAUTH_LEAVING)
Jul 17 20:35:19 Joanie avahi-daemon[15386]: Leaving mDNS multicast group on interface wlp3s0.IPv4 with address 10.10.10.100.
Jul 17 20:35:19 Joanie avahi-daemon[15386]: Interface wlp3s0.IPv4 no longer relevant for mDNS.
Jul 17 20:35:19 Joanie org.gtk.vfs.Daemon[1873]: ** (process:3196): WARNING **: Couldn't create directory monitor on smb://x-gnome-default-workgroup/. Error: Operation not supported by backend
Jul 17 20:35:19 Joanie wpa_supplicant[1135]: wlp3s0: CTRL-EVENT-DISCONNECTED bssid=c0:8a:de:20:2f:68 reason=3 locally_generated=1
Jul 17 20:35:19 Joanie avahi-daemon[15386]: Withdrawing address record for fe80::bf52:2694:756c:4265 on wlp3s0.
Jul 17 20:35:19 Joanie NetworkManager[866]: <info>  [1531874119.9345] dns-mgr: Writing DNS information to /sbin/resolvconf
Jul 17 20:35:19 Joanie avahi-daemon[15386]: Leaving mDNS multicast group on interface wlp3s0.IPv6 with address fe80::bf52:2694:756c:4265.
Jul 17 20:35:19 Joanie avahi-daemon[15386]: Interface wlp3s0.IPv6 no longer relevant for mDNS.
Jul 17 20:35:19 Joanie dnsmasq[1324]: setting upstream servers from DBus
Jul 17 20:35:19 Joanie wpa_supplicant[1135]: wlp3s0: CTRL-EVENT-REGDOM-CHANGE init=CORE type=WORLD
Jul 17 20:35:19 Joanie kernel: [8611028.053577] cfg80211: World regulatory domain updated:
Jul 17 20:35:19 Joanie kernel: [8611028.053584] cfg80211:  DFS Master region: unset
Jul 17 20:35:19 Joanie kernel: [8611028.053586] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
Jul 17 20:35:19 Joanie kernel: [8611028.053591] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
Jul 17 20:35:19 Joanie kernel: [8611028.053594] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
Jul 17 20:35:19 Joanie kernel: [8611028.053597] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
Jul 17 20:35:19 Joanie kernel: [8611028.053601] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (N/A)
Jul 17 20:35:19 Joanie kernel: [8611028.053604] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (0 s)
Jul 17 20:35:19 Joanie kernel: [8611028.053608] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
Jul 17 20:35:19 Joanie kernel: [8611028.053611] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
Jul 17 20:35:19 Joanie kernel: [8611028.053614] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
Jul 17 20:35:19 Joanie NetworkManager[866]: <info>  [1531874119.9536] manager: NetworkManager state is now ASLEEP
Jul 17 20:35:19 Joanie dbus[850]: [system] Activating via systemd: service name='org.freedesktop.nm_dispatcher' unit='dbus-org.freedesktop.nm-dispatcher.service'
Jul 17 20:35:20 Joanie systemd[1]: Starting Network Manager Script Dispatcher Service...
Jul 17 20:35:20 Joanie systemd[1]: Reached target Sleep.
Jul 17 20:35:20 Joanie systemd[1]: Starting Suspend...
Jul 17 20:35:20 Joanie wpa_supplicant[1135]: nl80211: deinit ifname=wlp3s0 disabled_11b_rates=0
Jul 17 20:35:20 Joanie dbus[850]: [system] Successfully activated service 'org.freedesktop.nm_dispatcher'
Jul 17 20:35:20 Joanie systemd[1]: Started Network Manager Script Dispatcher Service.
Jul 17 20:35:20 Joanie nm-dispatcher: req:1 'down' [wlp3s0]: new request (1 scripts)
Jul 17 20:35:20 Joanie nm-dispatcher: req:1 'down' [wlp3s0]: start running ordered scripts...
Jul 17 20:35:21 Joanie ntpd[14595]: Deleting interface #24 wlp3s0, 10.10.10.100#123, interface stats: received=322, sent=346, dropped=0, active_time=11583 secs
Jul 17 20:35:21 Joanie ntpd[14595]: 108.61.73.244 local addr 10.10.10.100 -> <null>
Jul 17 20:35:21 Joanie ntpd[14595]: 98.191.213.14 local addr 10.10.10.100 -> <null>
Jul 17 20:35:21 Joanie ntpd[14595]: 129.6.15.30 local addr 10.10.10.100 -> <null>
Jul 17 20:35:21 Joanie ntpd[14595]: 69.89.207.99 local addr 10.10.10.100 -> <null>
Jul 17 20:35:21 Joanie ntpd[14595]: 129.6.15.28 local addr 10.10.10.100 -> <null>
Jul 17 20:35:21 Joanie ntpd[14595]: 216.93.242.12 local addr 10.10.10.100 -> <null>
Jul 17 20:35:21 Joanie ntpd[14595]: 12.167.151.1 local addr 10.10.10.100 -> <null>
Jul 17 20:35:21 Joanie ntpd[14595]: 128.10.19.24 local addr 10.10.10.100 -> <null>
Jul 17 20:35:21 Joanie ntpd[14595]: 162.221.74.15 local addr 10.10.10.100 -> <null>
Jul 17 20:35:21 Joanie ntpd[14595]: 45.56.105.98 local addr 10.10.10.100 -> <null>
Jul 17 20:35:21 Joanie ntpd[14595]: 71.19.144.130 local addr 10.10.10.100 -> <null>
Jul 17 20:35:21 Joanie ntpd[14595]: Deleting interface #25 wlp3s0, fe80::bf52:2694:756c:4265%3#123, interface stats: received=0, sent=0, dropped=0, active_time=11583 secs
Jul 17 20:35:25 Joanie kernel: [8611033.799377] atkbd serio0: Unknown key pressed (translated set 2, code 0xf1 on isa0060/serio0).
Jul 17 20:35:25 Joanie kernel: [8611033.799437] atkbd serio0: Use 'setkeycodes e071 <keycode>' to make it known.
Jul 17 20:35:25 Joanie kernel: [8611033.810024] atkbd serio0: Unknown key released (translated set 2, code 0xf1 on isa0060/serio0).
Jul 17 20:35:25 Joanie kernel: [8611033.810030] atkbd serio0: Use 'setkeycodes e071 <keycode>' to make it known.
Jul 17 20:35:30 Joanie systemd-sleep[9991]: Selected interface 'wlp3s0'
Jul 17 20:35:30 Joanie systemd-sleep[9991]: 'SUSPEND' command timed out.
Jul 17 20:35:30 Joanie systemd-sleep[9994]: /lib/systemd/system-sleep/wpasupplicant failed with error code 254.
Jul 17 20:35:30 Joanie systemd-sleep[9991]: Suspending system...
Jul 17 20:35:30 Joanie kernel: [8611038.128938] PM: Syncing filesystems ... done.
Jul 17 20:35:30 Joanie kernel: [8611038.155057] PM: Preparing system for sleep (mem)
Aug  2 13:04:06 Joanie kernel: [8611038.157630] Freezing user space processes ... (elapsed 0.002 seconds) done.
Aug  2 13:04:06 Joanie kernel: [8611038.159737] Freezing remaining freezable tasks ... (elapsed 0.086 seconds) done.
Aug  2 13:04:06 Joanie kernel: [8611038.246170] PM: Suspending system (mem)
Aug  2 13:04:06 Joanie kernel: [8611038.246253] Suspending console(s) (use no_console_suspend to debug)
Aug  2 13:04:06 Joanie kernel: [8611038.408951] sd 0:0:0:0: [sda] Synchronizing SCSI cache
Aug  2 13:04:06 Joanie kernel: [8611038.409771] sd 0:0:0:0: [sda] Stopping disk
Aug  2 13:04:06 Joanie kernel: [8611038.699650] PM: suspend of devices complete after 453.198 msecs
Aug  2 13:04:06 Joanie kernel: [8611038.715972] PM: late suspend of devices complete after 16.316 msecs
Aug  2 13:04:06 Joanie kernel: [8611038.717347] r8169 0000:09:00.0: System wakeup enabled by ACPI
Aug  2 13:04:06 Joanie kernel: [8611038.717744] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
Aug  2 13:04:06 Joanie kernel: [8611038.717958] ehci-pci 0000:00:1a.0: System wakeup enabled by ACPI
Aug  2 13:04:06 Joanie kernel: [8611038.732101] PM: noirq suspend of devices complete after 16.125 msecs
Aug  2 13:04:06 Joanie kernel: [8611038.732275] ACPI: Preparing to enter system sleep state S3
Aug  2 13:04:06 Joanie kernel: [8611038.919913] ACPI : EC: EC stopped
Aug  2 13:04:06 Joanie kernel: [8611038.919915] PM: Saving platform NVS memory
Aug  2 13:04:06 Joanie kernel: [8611038.920885] Disabling non-boot CPUs ...
Aug  2 13:04:06 Joanie kernel: [8611038.922332] smpboot: CPU 1 is now offline
Aug  2 13:04:06 Joanie kernel: [8611038.932993] Broke affinity for irq 16
Aug  2 13:04:06 Joanie kernel: [8611038.933005] Broke affinity for irq 23
Aug  2 13:04:06 Joanie kernel: [8611038.933011] Broke affinity for irq 26
Aug  2 13:04:06 Joanie kernel: [8611038.934052] smpboot: CPU 2 is now offline
Aug  2 13:04:06 Joanie kernel: [8611038.944966] Broke affinity for irq 1
Aug  2 13:04:06 Joanie kernel: [8611038.944977] Broke affinity for irq 9
Aug  2 13:04:06 Joanie kernel: [8611038.944983] Broke affinity for irq 12
Aug  2 13:04:06 Joanie kernel: [8611038.944989] Broke affinity for irq 16
Aug  2 13:04:06 Joanie kernel: [8611038.945000] Broke affinity for irq 23
Aug  2 13:04:06 Joanie kernel: [8611038.945004] Broke affinity for irq 24
Aug  2 13:04:06 Joanie kernel: [8611038.945007] Broke affinity for irq 25
Aug  2 13:04:06 Joanie kernel: [8611038.945009] Broke affinity for irq 26
Aug  2 13:04:06 Joanie kernel: [8611038.945011] Broke affinity for irq 29
Aug  2 13:04:06 Joanie kernel: [8611038.946055] smpboot: CPU 3 is now offline
Aug  2 13:04:06 Joanie kernel: [8611038.957535] ACPI: Low-level resume complete
Aug  2 13:04:06 Joanie kernel: [8611038.957595] ACPI : EC: EC started
Aug  2 13:04:06 Joanie kernel: [8611038.957596] PM: Restoring platform NVS memory
Aug  2 13:04:06 Joanie kernel: [8611038.958162] Enabling non-boot CPUs ...
Aug  2 13:04:06 Joanie kernel: [8611038.977513] x86: Booting SMP configuration:
Aug  2 13:04:06 Joanie kernel: [8611038.977514] smpboot: Booting Node 0 Processor 1 APIC 0x4
Aug  2 13:04:06 Joanie kernel: [8611038.980117]  cache: parent cpu1 should not be sleeping
Aug  2 13:04:06 Joanie kernel: [8611038.980358] CPU1 is up
Aug  2 13:04:06 Joanie kernel: [8611038.997531] smpboot: Booting Node 0 Processor 2 APIC 0x1
Aug  2 13:04:06 Joanie kernel: [8611039.000026]  cache: parent cpu2 should not be sleeping
Aug  2 13:04:06 Joanie kernel: [8611039.000266] CPU2 is up
Aug  2 13:04:06 Joanie kernel: [8611039.013580] smpboot: Booting Node 0 Processor 3 APIC 0x5
Aug  2 13:04:06 Joanie kernel: [8611039.016097]  cache: parent cpu3 should not be sleeping
Aug  2 13:04:06 Joanie kernel: [8611039.016334] CPU3 is up
Aug  2 13:04:06 Joanie kernel: [8611039.018927] ACPI: Waking up from system sleep state S3
Aug  2 13:04:06 Joanie kernel: [8611039.201517] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
Aug  2 13:04:06 Joanie kernel: [8611039.201587] ehci-pci 0000:00:1a.0: System wakeup disabled by ACPI
Aug  2 13:04:06 Joanie kernel: [8611039.201932] PM: noirq resume of devices complete after 16.519 msecs
Aug  2 13:04:06 Joanie kernel: [8611039.204077] PM: early resume of devices complete after 2.124 msecs
Aug  2 13:04:06 Joanie kernel: [8611039.204338] r8169 0000:09:00.0: System wakeup disabled by ACPI
Aug  2 13:04:06 Joanie kernel: [8611039.205588] sd 0:0:0:0: [sda] Starting disk
Aug  2 13:04:06 Joanie kernel: [8611039.258825] r8169 0000:09:00.0 enp9s0: link down
Aug  2 13:04:06 Joanie kernel: [8611039.313733] rtc_cmos 00:02: System wakeup disabled by ACPI
Aug  2 13:04:06 Joanie kernel: [8611039.433353] usb 1-1.3: reset full-speed USB device number 3 using ehci-pci
Aug  2 13:04:06 Joanie kernel: [8611039.437354] usb 2-1.2: reset high-speed USB device number 7 using ehci-pci
Aug  2 13:04:06 Joanie kernel: [8611039.525373] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug  2 13:04:06 Joanie kernel: [8611039.525635] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
Aug  2 13:04:06 Joanie kernel: [8611039.525639] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
Aug  2 13:04:06 Joanie kernel: [8611039.526182] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
Aug  2 13:04:06 Joanie kernel: [8611039.526185] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
Aug  2 13:04:06 Joanie kernel: [8611039.526482] ata1.00: configured for UDMA/133
Aug  2 13:04:06 Joanie kernel: [8611039.533326] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Aug  2 13:04:06 Joanie kernel: [8611039.533906] ata2.00: unexpected _GTF length (8)
Aug  2 13:04:06 Joanie kernel: [8611039.535365] ata2.00: unexpected _GTF length (8)
Aug  2 13:04:06 Joanie kernel: [8611039.535369] ata2.00: configured for UDMA/100
Aug  2 13:04:06 Joanie kernel: [8611039.541402] ata6: SATA link down (SStatus 0 SControl 300)
Aug  2 13:04:06 Joanie kernel: [8611039.549325] ata5: SATA link down (SStatus 0 SControl 300)
Aug  2 13:04:06 Joanie kernel: [8611039.597342] usb 1-1.6: reset full-speed USB device number 5 using ehci-pci
Aug  2 13:04:06 Joanie kernel: [8611039.601306] usb 2-1.4: reset high-speed USB device number 3 using ehci-pci
Aug  2 13:04:06 Joanie kernel: [8611039.702104] PM: resume of devices complete after 498.051 msecs
Aug  2 13:04:06 Joanie kernel: [8611039.702790] PM: Finishing wakeup.
Aug  2 13:04:06 Joanie systemd[1]: Time has been changed
Aug  2 13:04:06 Joanie systemd[1806]: Time has been changed
Aug  2 13:04:06 Joanie kernel: [8611039.702792] Restarting tasks ... done.
Aug  2 13:04:06 Joanie bluetoothd[23268]: Failed to obtain handles for "Service Changed" characteristic
Aug  2 13:04:06 Joanie kernel: [8611039.773444] video LNXVIDEO:01: Restoring backlight state
Aug  2 13:04:06 Joanie bluetoothd[23268]: Not enough free handles to register service
Aug  2 13:04:06 Joanie bluetoothd[23268]: Error adding Link Loss service
Aug  2 13:04:06 Joanie bluetoothd[23268]: Not enough free handles to register service
Aug  2 13:04:06 Joanie systemd-sleep[9991]: System resumed.
Aug  2 13:04:06 Joanie bluetoothd[23268]: Not enough free handles to register service
Aug  2 13:04:06 Joanie bluetoothd[23268]: Not enough free handles to register service
Aug  2 13:04:06 Joanie bluetoothd[23268]: Current Time Service could not be registered
Aug  2 13:04:06 Joanie bluetoothd[23268]: gatt-time-server: Input/output error (5)
Aug  2 13:04:06 Joanie bluetoothd[23268]: Not enough free handles to register service
Aug  2 13:04:06 Joanie bluetoothd[23268]: Not enough free handles to register service
Aug  2 13:04:06 Joanie bluetoothd[23268]: Sap driver initialization failed.
Aug  2 13:04:06 Joanie bluetoothd[23268]: sap-server: Operation not permitted (1)
Aug  2 13:04:06 Joanie systemd-sleep[9991]: Failed to connect to non-global ctrl_ifname: (nil)  error: No such file or directory
Aug  2 13:04:06 Joanie systemd-sleep[9991]: /dev/sda:
Aug  2 13:04:06 Joanie systemd-sleep[9991]:  setting Advanced Power Management level to 0x80 (128)
Aug  2 13:04:06 Joanie systemd-sleep[9991]:  APM_level#011= 128
Aug  2 13:04:06 Joanie systemd[1]: Starting Load/Save RF Kill Switch Status...
Aug  2 13:04:06 Joanie systemd[1]: bluetooth.target: Unit not needed anymore. Stopping.
Aug  2 13:04:06 Joanie systemd[1]: Started Load/Save RF Kill Switch Status.
Aug  2 13:04:06 Joanie systemd[1]: Stopped target Bluetooth.
Aug  2 13:04:07 Joanie systemd-sleep[9991]: /dev/sda:
Aug  2 13:04:07 Joanie systemd-sleep[9991]:  setting standby to 36 (3 minutes)
Aug  2 13:04:07 Joanie systemd-sleep[10145]: /lib/systemd/system-sleep/wpasupplicant failed with error code 255.
Aug  2 13:04:07 Joanie systemd[1]: Started Suspend.
Aug  2 13:04:07 Joanie systemd[1]: sleep.target: Unit not needed anymore. Stopping.
Aug  2 13:04:07 Joanie systemd[1]: Stopped target Sleep.
Aug  2 13:04:07 Joanie systemd[1]: Reached target Suspend.
Aug  2 13:04:07 Joanie systemd[1]: suspend.target: Unit is bound to inactive unit systemd-suspend.service. Stopping, too.
Aug  2 13:04:07 Joanie systemd[1]: Stopped target Suspend.
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.1162] manager: wake requested (sleeping: yes  enabled: yes)
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.1163] manager: waking up...
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.1164] device (enp9s0): state change: unavailable -> unmanaged (reason 'sleeping') [20 10 37]
Aug  2 13:04:07 Joanie systemd[1]: Started Run anacron jobs at resume.
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.1373] device (wlp3s0): state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
Aug  2 13:04:07 Joanie kernel: [8611040.139646] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
Aug  2 13:04:07 Joanie kernel: [8611040.139825] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  2 13:04:07 Joanie kernel: [8611040.147373] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  2 13:04:07 Joanie kernel: [8611040.147473] iwlwifi 0000:03:00.0: Radio type=0x0-0x0-0x3
Aug  2 13:04:07 Joanie kernel: [8611040.182802] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  2 13:04:07 Joanie kernel: [8611040.190302] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  2 13:04:07 Joanie kernel: [8611040.190401] iwlwifi 0000:03:00.0: Radio type=0x0-0x0-0x3
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.2256] device (enp9s0): state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
Aug  2 13:04:07 Joanie kernel: [8611040.225382] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
Aug  2 13:04:07 Joanie kernel: [8611040.227991] IPv6: ADDRCONF(NETDEV_UP): enp9s0: link is not ready
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.2823] manager: NetworkManager state is now DISCONNECTED
Aug  2 13:04:07 Joanie kernel: [8611040.282630] r8169 0000:09:00.0 enp9s0: link down
Aug  2 13:04:07 Joanie kernel: [8611040.282755] IPv6: ADDRCONF(NETDEV_UP): enp9s0: link is not ready
Aug  2 13:04:07 Joanie wpa_supplicant[1135]: dbus: wpa_dbus_get_object_properties: failed to get object properties: (none) none
Aug  2 13:04:07 Joanie wpa_supplicant[1135]: dbus: Failed to construct signal
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.3323] device (wlp3s0): supplicant interface state: starting -> ready
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.3324] device (wlp3s0): state change: unavailable -> disconnected (reason 'supplicant-available') [20 30 42]
Aug  2 13:04:07 Joanie kernel: [8611040.334833] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
Aug  2 13:04:07 Joanie kernel: [8611040.364881] psmouse serio4: synaptics: queried max coordinates: x [..5856], y [..4938]
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.7877] device (wlp3s0): supplicant interface state: ready -> inactive
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.7922] policy: auto-activating connection 'VoicePlex'
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.7934] device (wlp3s0): Activation: starting connection 'VoicePlex' (cf0aa26d-621a-4742-bf42-0b0a1644f3ca)
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.7936] device (wlp3s0): state change: disconnected -> prepare (reason 'none') [30 40 0]
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.7938] manager: NetworkManager state is now CONNECTING
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.7945] device (wlp3s0): state change: prepare -> config (reason 'none') [40 50 0]
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.7951] device (wlp3s0): Activation: (wifi) access point 'VoicePlex' has security, but secrets are required.
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.7952] device (wlp3s0): state change: config -> need-auth (reason 'none') [50 60 0]
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.7994] device (wlp3s0): state change: need-auth -> prepare (reason 'none') [60 40 0]
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.8000] device (wlp3s0): state change: prepare -> config (reason 'none') [40 50 0]
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.8003] device (wlp3s0): Activation: (wifi) connection 'VoicePlex' has security, and secrets exist.  No new secrets needed.
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.8004] Config: added 'ssid' value 'VoicePlex'
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.8004] Config: added 'scan_ssid' value '1'
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.8005] Config: added 'key_mgmt' value 'WPA-PSK'
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.8005] Config: added 'auth_alg' value 'OPEN'
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.8005] Config: added 'psk' value '<omitted>'
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.8035] sup-iface[0xaa36e0,wlp3s0]: config: set interface ap_scan to 1
Aug  2 13:04:07 Joanie wpa_supplicant[1135]: wlp3s0: SME: Trying to authenticate with c0:8a:de:20:2f:68 (SSID='VoicePlex' freq=2412 MHz)
Aug  2 13:04:07 Joanie kernel: [8611040.817622] wlp3s0: authenticate with c0:8a:de:20:2f:68
Aug  2 13:04:07 Joanie wpa_supplicant[1135]: wlp3s0: Trying to associate with c0:8a:de:20:2f:68 (SSID='VoicePlex' freq=2412 MHz)
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.8220] device (wlp3s0): supplicant interface state: inactive -> authenticating
Aug  2 13:04:07 Joanie kernel: [8611040.821344] wlp3s0: send auth to c0:8a:de:20:2f:68 (try 1/3)
Aug  2 13:04:07 Joanie kernel: [8611040.822859] wlp3s0: authenticated
Aug  2 13:04:07 Joanie kernel: [8611040.823050] wlp3s0: waiting for beacon from c0:8a:de:20:2f:68
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.8267] device (wlp3s0): supplicant interface state: authenticating -> associating
Aug  2 13:04:07 Joanie kernel: [8611040.849275] wlp3s0: associate with c0:8a:de:20:2f:68 (try 1/3)
Aug  2 13:04:07 Joanie kernel: [8611040.853294] wlp3s0: RX AssocResp from c0:8a:de:20:2f:68 (capab=0x431 status=0 aid=2)
Aug  2 13:04:07 Joanie wpa_supplicant[1135]: wlp3s0: Associated with c0:8a:de:20:2f:68
Aug  2 13:04:07 Joanie kernel: [8611040.857276] wlp3s0: associated
Aug  2 13:04:07 Joanie kernel: [8611040.857381] IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s0: link becomes ready
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.8617] device (wlp3s0): supplicant interface state: associating -> 4-way handshake
Aug  2 13:04:07 Joanie wpa_supplicant[1135]: wlp3s0: WPA: Key negotiation completed with c0:8a:de:20:2f:68 [PTK=CCMP GTK=CCMP]
Aug  2 13:04:07 Joanie wpa_supplicant[1135]: wlp3s0: CTRL-EVENT-CONNECTED - Connection to c0:8a:de:20:2f:68 completed [id=0 id_str=]
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.8705] device (wlp3s0): supplicant interface state: 4-way handshake -> completed
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.8706] device (wlp3s0): Activation: (wifi) Stage 2 of 5 (Device Configure) successful.  Connected to wireless network 'VoicePlex'.
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.8707] device (wlp3s0): state change: config -> ip-config (reason 'none') [50 70 0]
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.8714] dhcp4 (wlp3s0): activation: beginning transaction (timeout in 45 seconds)
Aug  2 13:04:07 Joanie NetworkManager[866]: <info>  [1533229447.8769] dhcp4 (wlp3s0): dhclient started with pid 10205
Aug  2 13:04:08 Joanie dhclient[10205]: DHCPDISCOVER on wlp3s0 to 255.255.255.255 port 67 interval 3 (xid=0x1176562f)
Aug  2 13:04:08 Joanie dhclient[10205]: DHCPREQUEST of 10.10.10.100 on wlp3s0 to 255.255.255.255 port 67 (xid=0x2f567611)
Aug  2 13:04:08 Joanie dhclient[10205]: DHCPOFFER of 10.10.10.100 from 10.10.10.254
Aug  2 13:04:08 Joanie dhclient[10205]: DHCPACK of 10.10.10.100 from 10.10.10.254
Aug  2 13:04:08 Joanie NetworkManager[866]: <info>  [1533229448.3481]   address 10.10.10.100
Aug  2 13:04:08 Joanie NetworkManager[866]: <info>  [1533229448.3481]   plen 24 (255.255.255.0)
Aug  2 13:04:08 Joanie NetworkManager[866]: <info>  [1533229448.3482]   gateway 10.10.10.254
Aug  2 13:04:08 Joanie NetworkManager[866]: <info>  [1533229448.3482]   server identifier 10.10.10.254
Aug  2 13:04:08 Joanie NetworkManager[866]: <info>  [1533229448.3483]   lease time 86400
Aug  2 13:04:08 Joanie NetworkManager[866]: <info>  [1533229448.3483]   hostname 'Joanie'
Aug  2 13:04:08 Joanie avahi-daemon[15386]: Joining mDNS multicast group on interface wlp3s0.IPv4 with address 10.10.10.100.
Aug  2 13:04:08 Joanie NetworkManager[866]: <info>  [1533229448.3483]   nameserver '10.10.10.254'
Aug  2 13:04:08 Joanie avahi-daemon[15386]: New relevant interface wlp3s0.IPv4 for mDNS.
Aug  2 13:04:08 Joanie NetworkManager[866]: <info>  [1533229448.3484] dhcp4 (wlp3s0): state changed unknown -> bound
Aug  2 13:04:08 Joanie avahi-daemon[15386]: Registering new address record for 10.10.10.100 on wlp3s0.IPv4.
Aug  2 13:04:08 Joanie NetworkManager[866]: <info>  [1533229448.3531] device (wlp3s0): state change: ip-config -> ip-check (reason 'none') [70 80 0]
Aug  2 13:04:08 Joanie NetworkManager[866]: <info>  [1533229448.3544] device (wlp3s0): state change: ip-check -> secondaries (reason 'none') [80 90 0]
Aug  2 13:04:08 Joanie NetworkManager[866]: <info>  [1533229448.3572] device (wlp3s0): state change: secondaries -> activated (reason 'none') [90 100 0]
Aug  2 13:04:08 Joanie NetworkManager[866]: <info>  [1533229448.3575] manager: NetworkManager state is now CONNECTED_LOCAL
Aug  2 13:04:08 Joanie dhclient[10205]: bound to 10.10.10.100 -- renewal in 39731 seconds.
Aug  2 13:04:08 Joanie NetworkManager[866]: <info>  [1533229448.3649] manager: NetworkManager state is now CONNECTED_GLOBAL
Aug  2 13:04:08 Joanie dnsmasq[1324]: setting upstream servers from DBus
Aug  2 13:04:08 Joanie NetworkManager[866]: <info>  [1533229448.3651] policy: set 'VoicePlex' (wlp3s0) as default for IPv4 routing and DNS
Aug  2 13:04:08 Joanie dnsmasq[1324]: using nameserver 10.10.10.254#53
Aug  2 13:04:08 Joanie NetworkManager[866]: <info>  [1533229448.3654] dns-mgr: Writing DNS information to /sbin/resolvconf
Aug  2 13:04:08 Joanie NetworkManager[866]: <info>  [1533229448.3752] device (wlp3s0): Activation: successful, device activated.
Aug  2 13:04:08 Joanie dbus[850]: [system] Activating via systemd: service name='org.freedesktop.nm_dispatcher' unit='dbus-org.freedesktop.nm-dispatcher.service'
Aug  2 13:04:08 Joanie systemd[1]: Starting Network Manager Script Dispatcher Service...
Aug  2 13:04:08 Joanie dbus[850]: [system] Successfully activated service 'org.freedesktop.nm_dispatcher'
Aug  2 13:04:08 Joanie systemd[1]: Started Network Manager Script Dispatcher Service.
Aug  2 13:04:08 Joanie nm-dispatcher: req:1 'up' [wlp3s0]: new request (1 scripts)
Aug  2 13:04:08 Joanie nm-dispatcher: req:1 'up' [wlp3s0]: start running ordered scripts...
Aug  2 13:04:08 Joanie org.gtk.vfs.Daemon[1873]: ** (process:3196): WARNING **: Couldn't create directory monitor on smb://x-gnome-default-workgroup/. Error: Operation not supported by backend
Aug  2 13:04:08 Joanie ntpdate[10260]: the NTP socket is in use, exiting
Aug  2 13:04:08 Joanie avahi-daemon[15386]: Joining mDNS multicast group on interface wlp3s0.IPv6 with address fe80::bf52:2694:756c:4265.
Aug  2 13:04:08 Joanie avahi-daemon[15386]: New relevant interface wlp3s0.IPv6 for mDNS.
Aug  2 13:04:08 Joanie avahi-daemon[15386]: Registering new address record for fe80::bf52:2694:756c:4265 on wlp3s0.*.
Aug  2 13:04:10 Joanie ntpd[14595]: Listen normally on 26 wlp3s0 10.10.10.100:123
Aug  2 13:04:10 Joanie ntpd[14595]: Listen normally on 27 wlp3s0 [fe80::bf52:2694:756c:4265%3]:123
Aug  2 13:04:10 Joanie ntpd[14595]: new interface(s) found: waking up resolver
Aug  2 13:04:16 Joanie org.gtk.vfs.Daemon[1873]: ** (process:3196): WARNING **: Couldn't create directory monitor on smb://x-gnome-default-workgroup/. Error: Operation not supported by backend
Aug  2 13:04:21 Joanie ntpd[14595]: Soliciting pool server 216.229.0.50
Aug  2 13:04:22 Joanie ntpd[14595]: Soliciting pool server 45.63.11.93
Aug  2 13:04:13 Joanie systemd[1806]: Time has been changed
Aug  2 13:04:13 Joanie systemd[1]: Time has been changed
Aug  2 13:04:13 Joanie ntpd[14595]: receive: Unexpected origin timestamp from 128.10.19.24
Aug  2 13:04:28 Joanie ntpd[14595]: Soliciting pool server 91.189.89.198
Aug  2 13:04:29 Joanie ntpd[14595]: Soliciting pool server 91.189.89.199
Aug  2 13:04:30 Joanie ntpd[14595]: Soliciting pool server 91.189.94.4
Aug  2 13:08:05 Joanie dbus[850]: [system] Activating via systemd: service name='org.freedesktop.PackageKit' unit='packagekit.service'
Aug  2 13:08:05 Joanie systemd[1]: Starting PackageKit Daemon...
Aug  2 13:08:05 Joanie PackageKit: daemon start
Aug  2 13:08:05 Joanie dbus[850]: [system] Successfully activated service 'org.freedesktop.PackageKit'
Aug  2 13:08:05 Joanie systemd[1]: Started PackageKit Daemon.
Aug  2 13:08:40 Joanie NetworkManager[866]: <info>  [1533229720.4805] manager: sleep requested (sleeping: no  enabled: yes)
Aug  2 13:08:40 Joanie NetworkManager[866]: <info>  [1533229720.4806] manager: sleeping...
Aug  2 13:08:40 Joanie NetworkManager[866]: <info>  [1533229720.4806] device (wlp3s0): state change: activated -> unmanaged (reason 'sleeping') [100 10 37]
Aug  2 13:08:40 Joanie NetworkManager[866]: <info>  [1533229720.5138] dhcp4 (wlp3s0): canceled DHCP transaction, DHCP client pid 10205
Aug  2 13:08:40 Joanie NetworkManager[866]: <info>  [1533229720.5139] dhcp4 (wlp3s0): state changed bound -> done
Aug  2 13:08:40 Joanie kernel: [8611324.337418] wlp3s0: deauthenticating from c0:8a:de:20:2f:68 by local choice (Reason: 3=DEAUTH_LEAVING)
Aug  2 13:08:40 Joanie wpa_supplicant[1135]: wlp3s0: CTRL-EVENT-DISCONNECTED bssid=c0:8a:de:20:2f:68 reason=3 locally_generated=1
Aug  2 13:08:40 Joanie avahi-daemon[15386]: Withdrawing address record for 10.10.10.100 on wlp3s0.
Aug  2 13:08:40 Joanie avahi-daemon[15386]: Leaving mDNS multicast group on interface wlp3s0.IPv4 with address 10.10.10.100.
Aug  2 13:08:40 Joanie avahi-daemon[15386]: Interface wlp3s0.IPv4 no longer relevant for mDNS.
Aug  2 13:08:40 Joanie avahi-daemon[15386]: Withdrawing address record for fe80::bf52:2694:756c:4265 on wlp3s0.
Aug  2 13:08:40 Joanie avahi-daemon[15386]: Leaving mDNS multicast group on interface wlp3s0.IPv6 with address fe80::bf52:2694:756c:4265.
Aug  2 13:08:40 Joanie avahi-daemon[15386]: Interface wlp3s0.IPv6 no longer relevant for mDNS.
Aug  2 13:08:40 Joanie NetworkManager[866]: <info>  [1533229720.5306] dns-mgr: Writing DNS information to /sbin/resolvconf
Aug  2 13:08:40 Joanie dnsmasq[1324]: setting upstream servers from DBus
Aug  2 13:08:40 Joanie wpa_supplicant[1135]: wlp3s0: CTRL-EVENT-REGDOM-CHANGE init=CORE type=WORLD
Aug  2 13:08:40 Joanie kernel: [8611324.356835] cfg80211: World regulatory domain updated:
Aug  2 13:08:40 Joanie kernel: [8611324.356842] cfg80211:  DFS Master region: unset
Aug  2 13:08:40 Joanie kernel: [8611324.356846] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
Aug  2 13:08:40 Joanie kernel: [8611324.356851] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
Aug  2 13:08:40 Joanie kernel: [8611324.356856] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
Aug  2 13:08:40 Joanie kernel: [8611324.356859] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
Aug  2 13:08:40 Joanie kernel: [8611324.356864] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (N/A)
Aug  2 13:08:40 Joanie kernel: [8611324.356869] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (0 s)
Aug  2 13:08:40 Joanie kernel: [8611324.356873] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
Aug  2 13:08:40 Joanie kernel: [8611324.356878] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
Aug  2 13:08:40 Joanie kernel: [8611324.356881] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
Aug  2 13:08:40 Joanie org.gtk.vfs.Daemon[1873]: ** (process:3196): WARNING **: Couldn't create directory monitor on smb://x-gnome-default-workgroup/. Error: Operation not supported by backend
Aug  2 13:08:40 Joanie NetworkManager[866]: <info>  [1533229720.5528] manager: NetworkManager state is now ASLEEP
Aug  2 13:08:40 Joanie dbus[850]: [system] Activating via systemd: service name='org.freedesktop.nm_dispatcher' unit='dbus-org.freedesktop.nm-dispatcher.service'
Aug  2 13:08:40 Joanie systemd[1]: Reached target Sleep.
Aug  2 13:08:40 Joanie systemd[1]: Starting Suspend...
Aug  2 13:08:40 Joanie systemd[1]: Starting Network Manager Script Dispatcher Service...
Aug  2 13:08:40 Joanie wpa_supplicant[1135]: nl80211: deinit ifname=wlp3s0 disabled_11b_rates=0
Aug  2 13:08:40 Joanie dbus[850]: [system] Successfully activated service 'org.freedesktop.nm_dispatcher'
Aug  2 13:08:40 Joanie systemd[1]: Started Network Manager Script Dispatcher Service.
Aug  2 13:08:40 Joanie nm-dispatcher: req:1 'down' [wlp3s0]: new request (1 scripts)
Aug  2 13:08:40 Joanie nm-dispatcher: req:1 'down' [wlp3s0]: start running ordered scripts...
Aug  2 13:08:42 Joanie ntpd[14595]: Deleting interface #26 wlp3s0, 10.10.10.100#123, interface stats: received=158, sent=162, dropped=0, active_time=283 secs
Aug  2 13:08:42 Joanie ntpd[14595]: 91.189.94.4 local addr 10.10.10.100 -> <null>
Aug  2 13:08:42 Joanie ntpd[14595]: 91.189.89.199 local addr 10.10.10.100 -> <null>
Aug  2 13:08:42 Joanie ntpd[14595]: 91.189.89.198 local addr 10.10.10.100 -> <null>
Aug  2 13:08:42 Joanie ntpd[14595]: 45.63.11.93 local addr 10.10.10.100 -> <null>
Aug  2 13:08:42 Joanie ntpd[14595]: 216.229.0.50 local addr 10.10.10.100 -> <null>
Aug  2 13:08:42 Joanie ntpd[14595]: 98.191.213.14 local addr 10.10.10.100 -> <null>
Aug  2 13:08:42 Joanie ntpd[14595]: 129.6.15.30 local addr 10.10.10.100 -> <null>
Aug  2 13:08:42 Joanie ntpd[14595]: 69.89.207.99 local addr 10.10.10.100 -> <null>
Aug  2 13:08:42 Joanie ntpd[14595]: 129.6.15.28 local addr 10.10.10.100 -> <null>
Aug  2 13:08:42 Joanie ntpd[14595]: 216.93.242.12 local addr 10.10.10.100 -> <null>
Aug  2 13:08:42 Joanie ntpd[14595]: 12.167.151.1 local addr 10.10.10.100 -> <null>
Aug  2 13:08:42 Joanie ntpd[14595]: 128.10.19.24 local addr 10.10.10.100 -> <null>
Aug  2 13:08:42 Joanie ntpd[14595]: 162.221.74.15 local addr 10.10.10.100 -> <null>
Aug  2 13:08:42 Joanie ntpd[14595]: 45.56.105.98 local addr 10.10.10.100 -> <null>
Aug  2 13:08:42 Joanie ntpd[14595]: 71.19.144.130 local addr 10.10.10.100 -> <null>
Aug  2 13:08:42 Joanie ntpd[14595]: 108.61.73.244 local addr 10.10.10.100 -> <null>
Aug  2 13:08:42 Joanie ntpd[14595]: Deleting interface #27 wlp3s0, fe80::bf52:2694:756c:4265%3#123, interface stats: received=0, sent=0, dropped=0, active_time=283 secs
Aug  2 13:08:50 Joanie systemd-sleep[11077]: Selected interface 'wlp3s0'
Aug  2 13:08:50 Joanie systemd-sleep[11077]: 'SUSPEND' command timed out.
Aug  2 13:08:50 Joanie systemd-sleep[11083]: /lib/systemd/system-sleep/wpasupplicant failed with error code 254.
Aug  2 13:08:50 Joanie systemd-sleep[11077]: Suspending system...
Aug  4 07:59:44 Joanie kernel: [8611334.434426] PM: Syncing filesystems ... done.
Aug  4 07:59:44 Joanie kernel: [8611334.448917] PM: Preparing system for sleep (mem)
Aug  4 07:59:44 Joanie kernel: [8611334.449226] Freezing user space processes ... (elapsed 0.002 seconds) done.
Aug  4 07:59:44 Joanie kernel: [8611334.451298] Freezing remaining freezable tasks ... (elapsed 0.077 seconds) done.
Aug  4 07:59:44 Joanie kernel: [8611334.528985] PM: Suspending system (mem)
Aug  4 07:59:44 Joanie kernel: [8611334.529079] Suspending console(s) (use no_console_suspend to debug)
Aug  4 07:59:44 Joanie kernel: [8611334.696044] sd 0:0:0:0: [sda] Synchronizing SCSI cache
Aug  4 07:59:44 Joanie kernel: [8611334.696856] sd 0:0:0:0: [sda] Stopping disk
Aug  4 07:59:44 Joanie kernel: [8611334.970277] PM: suspend of devices complete after 440.999 msecs
Aug  4 07:59:44 Joanie kernel: [8611334.983356] PM: late suspend of devices complete after 13.074 msecs
Aug  4 07:59:44 Joanie kernel: [8611334.984754] r8169 0000:09:00.0: System wakeup enabled by ACPI
Aug  4 07:59:44 Joanie kernel: [8611334.984830] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
Aug  4 07:59:44 Joanie kernel: [8611334.985130] ehci-pci 0000:00:1a.0: System wakeup enabled by ACPI
Aug  4 07:59:44 Joanie kernel: [8611334.999261] PM: noirq suspend of devices complete after 15.901 msecs
Aug  4 07:59:44 Joanie kernel: [8611334.999447] ACPI: Preparing to enter system sleep state S3
Aug  4 07:59:44 Joanie kernel: [8611335.187408] ACPI : EC: EC stopped
Aug  4 07:59:44 Joanie kernel: [8611335.187409] PM: Saving platform NVS memory
Aug  4 07:59:44 Joanie kernel: [8611335.188479] Disabling non-boot CPUs ...
Aug  4 07:59:44 Joanie kernel: [8611335.190210] smpboot: CPU 1 is now offline
Aug  4 07:59:44 Joanie kernel: [8611335.204406] Broke affinity for irq 16
Aug  4 07:59:44 Joanie kernel: [8611335.204419] Broke affinity for irq 23
Aug  4 07:59:44 Joanie kernel: [8611335.204427] Broke affinity for irq 26
Aug  4 07:59:44 Joanie kernel: [8611335.205475] smpboot: CPU 2 is now offline
Aug  4 07:59:44 Joanie kernel: [8611335.216186] Broke affinity for irq 1
Aug  4 07:59:44 Joanie kernel: [8611335.216197] Broke affinity for irq 9
Aug  4 07:59:44 Joanie kernel: [8611335.216203] Broke affinity for irq 12
Aug  4 07:59:44 Joanie kernel: [8611335.216210] Broke affinity for irq 16
Aug  4 07:59:44 Joanie kernel: [8611335.216220] Broke affinity for irq 23
Aug  4 07:59:44 Joanie kernel: [8611335.216225] Broke affinity for irq 24
Aug  4 07:59:44 Joanie kernel: [8611335.216227] Broke affinity for irq 25
Aug  4 07:59:44 Joanie kernel: [8611335.216229] Broke affinity for irq 26
Aug  4 07:59:44 Joanie kernel: [8611335.216232] Broke affinity for irq 29
Aug  4 07:59:44 Joanie kernel: [8611335.217262] smpboot: CPU 3 is now offline
Aug  4 07:59:44 Joanie kernel: [8611335.228681] ACPI: Low-level resume complete
Aug  4 07:59:44 Joanie kernel: [8611335.228741] ACPI : EC: EC started
Aug  4 07:59:44 Joanie kernel: [8611335.228741] PM: Restoring platform NVS memory
Aug  4 07:59:44 Joanie kernel: [8611335.229306] Enabling non-boot CPUs ...
Aug  4 07:59:44 Joanie kernel: [8611335.248666] x86: Booting SMP configuration:
Aug  4 07:59:44 Joanie kernel: [8611335.248667] smpboot: Booting Node 0 Processor 1 APIC 0x4
Aug  4 07:59:44 Joanie kernel: [8611335.251270]  cache: parent cpu1 should not be sleeping
Aug  4 07:59:44 Joanie kernel: [8611335.251509] CPU1 is up
Aug  4 07:59:44 Joanie kernel: [8611335.268684] smpboot: Booting Node 0 Processor 2 APIC 0x1
Aug  4 07:59:44 Joanie kernel: [8611335.271186]  cache: parent cpu2 should not be sleeping
Aug  4 07:59:44 Joanie kernel: [8611335.271427] CPU2 is up
Aug  4 07:59:44 Joanie kernel: [8611335.284732] smpboot: Booting Node 0 Processor 3 APIC 0x5
Aug  4 07:59:44 Joanie kernel: [8611335.287345]  cache: parent cpu3 should not be sleeping
Aug  4 07:59:44 Joanie kernel: [8611335.287582] CPU3 is up
Aug  4 07:59:44 Joanie kernel: [8611335.290181] ACPI: Waking up from system sleep state S3
Aug  4 07:59:44 Joanie kernel: [8611335.476626] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
Aug  4 07:59:44 Joanie kernel: [8611335.476664] ehci-pci 0000:00:1a.0: System wakeup disabled by ACPI
Aug  4 07:59:44 Joanie kernel: [8611335.477063] PM: noirq resume of devices complete after 16.497 msecs
Aug  4 07:59:44 Joanie kernel: [8611335.479249] PM: early resume of devices complete after 2.160 msecs
Aug  4 07:59:44 Joanie kernel: [8611335.479572] r8169 0000:09:00.0: System wakeup disabled by ACPI
Aug  4 07:59:44 Joanie kernel: [8611335.479852] sd 0:0:0:0: [sda] Starting disk
Aug  4 07:59:44 Joanie kernel: [8611335.533987] r8169 0000:09:00.0 enp9s0: link down
Aug  4 07:59:44 Joanie kernel: [8611335.589852] rtc_cmos 00:02: System wakeup disabled by ACPI
Aug  4 07:59:44 Joanie kernel: [8611335.708505] usb 1-1.3: reset full-speed USB device number 3 using ehci-pci
Aug  4 07:59:44 Joanie kernel: [8611335.708527] usb 2-1.4: reset high-speed USB device number 3 using ehci-pci
Aug  4 07:59:44 Joanie kernel: [8611335.812494] ata5: SATA link down (SStatus 0 SControl 300)
Aug  4 07:59:44 Joanie kernel: [8611335.812530] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Aug  4 07:59:44 Joanie kernel: [8611335.813135] ata2.00: unexpected _GTF length (8)
Aug  4 07:59:44 Joanie kernel: [8611335.814615] ata2.00: unexpected _GTF length (8)
Aug  4 07:59:44 Joanie kernel: [8611335.814619] ata2.00: configured for UDMA/100
Aug  4 07:59:44 Joanie kernel: [8611335.820487] ata6: SATA link down (SStatus 0 SControl 300)
Aug  4 07:59:44 Joanie kernel: [8611335.872494] usb 1-1.6: reset full-speed USB device number 5 using ehci-pci
Aug  4 07:59:44 Joanie kernel: [8611335.876543] usb 2-1.2: reset high-speed USB device number 7 using ehci-pci
Aug  4 07:59:44 Joanie kernel: [8611335.973716] PM: resume of devices complete after 494.491 msecs
Aug  4 07:59:44 Joanie kernel: [8611335.974407] PM: Finishing wakeup.
Aug  4 07:59:44 Joanie systemd[1]: Time has been changed
Aug  4 07:59:44 Joanie systemd[1806]: Time has been changed
Aug  4 07:59:44 Joanie kernel: [8611335.974408] Restarting tasks ... done.
Aug  4 07:59:44 Joanie bluetoothd[23268]: Failed to obtain handles for "Service Changed" characteristic
Aug  4 07:59:44 Joanie bluetoothd[23268]: Not enough free handles to register service
Aug  4 07:59:44 Joanie bluetoothd[23268]: Error adding Link Loss service
Aug  4 07:59:44 Joanie bluetoothd[23268]: Not enough free handles to register service
Aug  4 07:59:44 Joanie bluetoothd[23268]: message repeated 2 times: [ Not enough free handles to register service]
Aug  4 07:59:44 Joanie bluetoothd[23268]: Current Time Service could not be registered
Aug  4 07:59:44 Joanie bluetoothd[23268]: gatt-time-server: Input/output error (5)
Aug  4 07:59:44 Joanie bluetoothd[23268]: Not enough free handles to register service
Aug  4 07:59:44 Joanie bluetoothd[23268]: Not enough free handles to register service
Aug  4 07:59:44 Joanie bluetoothd[23268]: Sap driver initialization failed.
Aug  4 07:59:44 Joanie bluetoothd[23268]: sap-server: Operation not permitted (1)
Aug  4 07:59:44 Joanie kernel: [8611336.048190] video LNXVIDEO:01: Restoring backlight state
Aug  4 07:59:44 Joanie systemd-sleep[11077]: System resumed.
Aug  4 07:59:44 Joanie systemd-sleep[11077]: Failed to connect to non-global ctrl_ifname: (nil)  error: No such file or directory
Aug  4 07:59:44 Joanie systemd[1]: Starting Load/Save RF Kill Switch Status...
Aug  4 07:59:44 Joanie kernel: [8611336.608600] psmouse serio4: synaptics: queried max coordinates: x [..5856], y [..4938]
Aug  4 07:59:44 Joanie kernel: [8611336.708481] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug  4 07:59:44 Joanie kernel: [8611336.709509] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
Aug  4 07:59:44 Joanie kernel: [8611336.709512] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
Aug  4 07:59:44 Joanie kernel: [8611336.710045] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
Aug  4 07:59:44 Joanie kernel: [8611336.710048] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
Aug  4 07:59:44 Joanie kernel: [8611336.712218] ata1.00: configured for UDMA/133
Aug  4 07:59:44 Joanie systemd[1]: Started Load/Save RF Kill Switch Status.
Aug  4 07:59:44 Joanie systemd[1]: Reached target Bluetooth.
Aug  4 07:59:45 Joanie systemd-sleep[11077]: /dev/sda:
Aug  4 07:59:45 Joanie systemd-sleep[11077]:  setting Advanced Power Management level to 0x80 (128)
Aug  4 07:59:45 Joanie systemd-sleep[11077]:  APM_level#011= 128
Aug  4 07:59:45 Joanie systemd-sleep[11077]: /dev/sda:
Aug  4 07:59:45 Joanie systemd-sleep[11077]:  setting standby to 36 (3 minutes)
Aug  4 07:59:45 Joanie systemd-sleep[11123]: /lib/systemd/system-sleep/wpasupplicant failed with error code 255.
Aug  4 07:59:45 Joanie systemd[1]: Started Suspend.
Aug  4 07:59:45 Joanie systemd[1]: sleep.target: Unit not needed anymore. Stopping.
Aug  4 07:59:45 Joanie systemd[1]: Stopped target Sleep.
Aug  4 07:59:45 Joanie systemd[1]: Reached target Suspend.
Aug  4 07:59:45 Joanie systemd[1]: suspend.target: Unit is bound to inactive unit systemd-suspend.service. Stopping, too.
Aug  4 07:59:45 Joanie systemd[1]: Stopped target Suspend.
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.2320] manager: wake requested (sleeping: yes  enabled: yes)
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.2320] manager: waking up...
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.2321] device (enp9s0): state change: unavailable -> unmanaged (reason 'sleeping') [20 10 37]
Aug  4 07:59:45 Joanie systemd[1]: Started Run anacron jobs at resume.
Aug  4 07:59:45 Joanie kernel: [8611337.080259] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.2567] device (wlp3s0): state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
Aug  4 07:59:45 Joanie kernel: [8611337.080706] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  4 07:59:45 Joanie kernel: [8611337.088216] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  4 07:59:45 Joanie kernel: [8611337.088338] iwlwifi 0000:03:00.0: Radio type=0x0-0x0-0x3
Aug  4 07:59:45 Joanie kernel: [8611337.126232] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  4 07:59:45 Joanie kernel: [8611337.133738] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  4 07:59:45 Joanie kernel: [8611337.133839] iwlwifi 0000:03:00.0: Radio type=0x0-0x0-0x3
Aug  4 07:59:45 Joanie kernel: [8611337.166790] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.3454] device (enp9s0): state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
Aug  4 07:59:45 Joanie kernel: [8611337.168886] IPv6: ADDRCONF(NETDEV_UP): enp9s0: link is not ready
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.4038] manager: NetworkManager state is now DISCONNECTED
Aug  4 07:59:45 Joanie kernel: [8611337.225699] r8169 0000:09:00.0 enp9s0: link down
Aug  4 07:59:45 Joanie kernel: [8611337.225772] IPv6: ADDRCONF(NETDEV_UP): enp9s0: link is not ready
Aug  4 07:59:45 Joanie wpa_supplicant[1135]: dbus: wpa_dbus_get_object_properties: failed to get object properties: (none) none
Aug  4 07:59:45 Joanie wpa_supplicant[1135]: dbus: Failed to construct signal
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.4566] device (wlp3s0): supplicant interface state: starting -> ready
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.4567] device (wlp3s0): state change: unavailable -> disconnected (reason 'supplicant-available') [20 30 42]
Aug  4 07:59:45 Joanie kernel: [8611337.279921] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.9221] device (wlp3s0): supplicant interface state: ready -> inactive
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.9304] policy: auto-activating connection 'VoicePlex'
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.9315] device (wlp3s0): Activation: starting connection 'VoicePlex' (cf0aa26d-621a-4742-bf42-0b0a1644f3ca)
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.9317] device (wlp3s0): state change: disconnected -> prepare (reason 'none') [30 40 0]
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.9319] manager: NetworkManager state is now CONNECTING
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.9326] device (wlp3s0): state change: prepare -> config (reason 'none') [40 50 0]
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.9330] device (wlp3s0): Activation: (wifi) access point 'VoicePlex' has security, but secrets are required.
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.9330] device (wlp3s0): state change: config -> need-auth (reason 'none') [50 60 0]
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.9423] device (wlp3s0): state change: need-auth -> prepare (reason 'none') [60 40 0]
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.9428] device (wlp3s0): state change: prepare -> config (reason 'none') [40 50 0]
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.9431] device (wlp3s0): Activation: (wifi) connection 'VoicePlex' has security, and secrets exist.  No new secrets needed.
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.9431] Config: added 'ssid' value 'VoicePlex'
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.9432] Config: added 'scan_ssid' value '1'
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.9432] Config: added 'key_mgmt' value 'WPA-PSK'
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.9432] Config: added 'auth_alg' value 'OPEN'
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.9432] Config: added 'psk' value '<omitted>'
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.9492] sup-iface[0xb0f640,wlp3s0]: config: set interface ap_scan to 1
Aug  4 07:59:45 Joanie wpa_supplicant[1135]: wlp3s0: SME: Trying to authenticate with c0:8a:de:20:2f:68 (SSID='VoicePlex' freq=2412 MHz)
Aug  4 07:59:45 Joanie kernel: [8611337.783889] wlp3s0: authenticate with c0:8a:de:20:2f:68
Aug  4 07:59:45 Joanie kernel: [8611337.785447] wlp3s0: send auth to c0:8a:de:20:2f:68 (try 1/3)
Aug  4 07:59:45 Joanie kernel: [8611337.788109] wlp3s0: authenticated
Aug  4 07:59:45 Joanie wpa_supplicant[1135]: wlp3s0: Trying to associate with c0:8a:de:20:2f:68 (SSID='VoicePlex' freq=2412 MHz)
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.9665] device (wlp3s0): supplicant interface state: inactive -> associating
Aug  4 07:59:45 Joanie kernel: [8611337.792322] wlp3s0: associate with c0:8a:de:20:2f:68 (try 1/3)
Aug  4 07:59:45 Joanie wpa_supplicant[1135]: wlp3s0: Associated with c0:8a:de:20:2f:68
Aug  4 07:59:45 Joanie kernel: [8611337.800423] wlp3s0: RX AssocResp from c0:8a:de:20:2f:68 (capab=0x431 status=0 aid=2)
Aug  4 07:59:45 Joanie kernel: [8611337.803737] wlp3s0: associated
Aug  4 07:59:45 Joanie kernel: [8611337.803812] IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s0: link becomes ready
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.9869] device (wlp3s0): supplicant interface state: associating -> 4-way handshake
Aug  4 07:59:45 Joanie wpa_supplicant[1135]: wlp3s0: WPA: Key negotiation completed with c0:8a:de:20:2f:68 [PTK=CCMP GTK=CCMP]
Aug  4 07:59:45 Joanie wpa_supplicant[1135]: wlp3s0: CTRL-EVENT-CONNECTED - Connection to c0:8a:de:20:2f:68 completed [id=0 id_str=]
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.9964] device (wlp3s0): supplicant interface state: 4-way handshake -> completed
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.9965] device (wlp3s0): Activation: (wifi) Stage 2 of 5 (Device Configure) successful.  Connected to wireless network 'VoicePlex'.
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.9967] device (wlp3s0): state change: config -> ip-config (reason 'none') [50 70 0]
Aug  4 07:59:45 Joanie NetworkManager[866]: <info>  [1533383985.9975] dhcp4 (wlp3s0): activation: beginning transaction (timeout in 45 seconds)
Aug  4 07:59:46 Joanie NetworkManager[866]: <info>  [1533383986.0009] dhcp4 (wlp3s0): dhclient started with pid 11181
Aug  4 07:59:46 Joanie dhclient[11181]: DHCPDISCOVER on wlp3s0 to 255.255.255.255 port 67 interval 3 (xid=0xe0533a77)
Aug  4 07:59:46 Joanie dhclient[11181]: DHCPREQUEST of 10.10.10.100 on wlp3s0 to 255.255.255.255 port 67 (xid=0x773a53e0)
Aug  4 07:59:46 Joanie dhclient[11181]: DHCPOFFER of 10.10.10.100 from 10.10.10.254
Aug  4 07:59:46 Joanie dhclient[11181]: DHCPACK of 10.10.10.100 from 10.10.10.254
Aug  4 07:59:46 Joanie NetworkManager[866]: <info>  [1533383986.4642]   address 10.10.10.100
Aug  4 07:59:46 Joanie NetworkManager[866]: <info>  [1533383986.4642]   plen 24 (255.255.255.0)
Aug  4 07:59:46 Joanie NetworkManager[866]: <info>  [1533383986.4642]   gateway 10.10.10.254
Aug  4 07:59:46 Joanie NetworkManager[866]: <info>  [1533383986.4642]   server identifier 10.10.10.254
Aug  4 07:59:46 Joanie NetworkManager[866]: <info>  [1533383986.4643]   lease time 86400
Aug  4 07:59:46 Joanie NetworkManager[866]: <info>  [1533383986.4643]   hostname 'Joanie'
Aug  4 07:59:46 Joanie NetworkManager[866]: <info>  [1533383986.4643]   nameserver '10.10.10.254'
Aug  4 07:59:46 Joanie NetworkManager[866]: <info>  [1533383986.4643] dhcp4 (wlp3s0): state changed unknown -> bound
Aug  4 07:59:46 Joanie avahi-daemon[15386]: Joining mDNS multicast group on interface wlp3s0.IPv4 with address 10.10.10.100.
Aug  4 07:59:46 Joanie avahi-daemon[15386]: New relevant interface wlp3s0.IPv4 for mDNS.
Aug  4 07:59:46 Joanie NetworkManager[866]: <info>  [1533383986.4663] device (wlp3s0): state change: ip-config -> ip-check (reason 'none') [70 80 0]
Aug  4 07:59:46 Joanie avahi-daemon[15386]: Registering new address record for 10.10.10.100 on wlp3s0.IPv4.
Aug  4 07:59:46 Joanie NetworkManager[866]: <info>  [1533383986.4672] device (wlp3s0): state change: ip-check -> secondaries (reason 'none') [80 90 0]
Aug  4 07:59:46 Joanie NetworkManager[866]: <info>  [1533383986.4678] device (wlp3s0): state change: secondaries -> activated (reason 'none') [90 100 0]
Aug  4 07:59:46 Joanie NetworkManager[866]: <info>  [1533383986.4680] manager: NetworkManager state is now CONNECTED_LOCAL
Aug  4 07:59:46 Joanie dhclient[11181]: bound to 10.10.10.100 -- renewal in 43014 seconds.
Aug  4 07:59:46 Joanie NetworkManager[866]: <info>  [1533383986.4849] manager: NetworkManager state is now CONNECTED_GLOBAL
Aug  4 07:59:46 Joanie NetworkManager[866]: <info>  [1533383986.4851] policy: set 'VoicePlex' (wlp3s0) as default for IPv4 routing and DNS
Aug  4 07:59:46 Joanie NetworkManager[866]: <info>  [1533383986.4853] dns-mgr: Writing DNS information to /sbin/resolvconf
Aug  4 07:59:46 Joanie dnsmasq[1324]: setting upstream servers from DBus
Aug  4 07:59:46 Joanie dnsmasq[1324]: using nameserver 10.10.10.254#53
Aug  4 07:59:46 Joanie NetworkManager[866]: <info>  [1533383986.4943] device (wlp3s0): Activation: successful, device activated.
Aug  4 07:59:46 Joanie dbus[850]: [system] Activating via systemd: service name='org.freedesktop.nm_dispatcher' unit='dbus-org.freedesktop.nm-dispatcher.service'
Aug  4 07:59:46 Joanie systemd[1]: Starting Network Manager Script Dispatcher Service...
Aug  4 07:59:46 Joanie dbus[850]: [system] Successfully activated service 'org.freedesktop.nm_dispatcher'
Aug  4 07:59:46 Joanie systemd[1]: Started Network Manager Script Dispatcher Service.
Aug  4 07:59:46 Joanie nm-dispatcher: req:1 'up' [wlp3s0]: new request (1 scripts)
Aug  4 07:59:46 Joanie nm-dispatcher: req:1 'up' [wlp3s0]: start running ordered scripts...
Aug  4 07:59:46 Joanie org.gtk.vfs.Daemon[1873]: ** (process:3196): WARNING **: Couldn't create directory monitor on smb://x-gnome-default-workgroup/. Error: Operation not supported by backend
Aug  4 07:59:46 Joanie org.gtk.vfs.Daemon[1873]: ** (process:3196): WARNING **: Couldn't create directory monitor on smb://x-gnome-default-workgroup/. Error: Operation not supported by backend
Aug  4 07:59:46 Joanie ntpdate[11236]: the NTP socket is in use, exiting
Aug  4 07:59:47 Joanie avahi-daemon[15386]: Joining mDNS multicast group on interface wlp3s0.IPv6 with address fe80::bf52:2694:756c:4265.
Aug  4 07:59:47 Joanie avahi-daemon[15386]: New relevant interface wlp3s0.IPv6 for mDNS.
Aug  4 07:59:47 Joanie avahi-daemon[15386]: Registering new address record for fe80::bf52:2694:756c:4265 on wlp3s0.*.
Aug  4 07:59:49 Joanie ntpd[14595]: Listen normally on 28 wlp3s0 10.10.10.100:123
Aug  4 07:59:49 Joanie ntpd[14595]: Listen normally on 29 wlp3s0 [fe80::bf52:2694:756c:4265%3]:123
Aug  4 07:59:49 Joanie ntpd[14595]: new interface(s) found: waking up resolver
Aug  4 08:04:04 Joanie PackageKit: daemon quit
Aug  4 08:04:04 Joanie packagekitd[11033]: (packagekitd:11033): GLib-CRITICAL **: Source ID 9 was not found when attempting to remove it
Aug  4 08:04:56 Joanie systemd[1806]: Time has been changed
Aug  4 08:04:56 Joanie systemd[1]: Time has been changed
Aug  4 08:05:29 Joanie dbus[850]: [system] Activating via systemd: service name='org.freedesktop.PackageKit' unit='packagekit.service'
Aug  4 08:05:29 Joanie systemd[1]: Starting PackageKit Daemon...
Aug  4 08:05:29 Joanie PackageKit: daemon start
Aug  4 08:05:29 Joanie dbus[850]: [system] Successfully activated service 'org.freedesktop.PackageKit'
Aug  4 08:05:29 Joanie systemd[1]: Started PackageKit Daemon.
Aug  4 08:10:34 Joanie PackageKit: daemon quit
Aug  4 08:10:34 Joanie packagekitd[12146]: (packagekitd:12146): GLib-CRITICAL **: Source ID 9 was not found when attempting to remove it
Aug  4 08:17:01 Joanie CRON[13393]: (root) CMD (   cd / && run-parts --report /etc/cron.hourly)
Aug  4 08:18:31 Joanie NetworkManager[866]: <info>  [1533385111.4108] manager: sleep requested (sleeping: no  enabled: yes)
Aug  4 08:18:31 Joanie NetworkManager[866]: <info>  [1533385111.4109] manager: sleeping...
Aug  4 08:18:31 Joanie NetworkManager[866]: <info>  [1533385111.4109] device (wlp3s0): state change: activated -> unmanaged (reason 'sleeping') [100 10 37]
Aug  4 08:18:31 Joanie NetworkManager[866]: <info>  [1533385111.4274] dhcp4 (wlp3s0): canceled DHCP transaction, DHCP client pid 11181
Aug  4 08:18:31 Joanie NetworkManager[866]: <info>  [1533385111.4275] dhcp4 (wlp3s0): state changed bound -> done
Aug  4 08:18:31 Joanie kernel: [8612464.623967] wlp3s0: deauthenticating from c0:8a:de:20:2f:68 by local choice (Reason: 3=DEAUTH_LEAVING)
Aug  4 08:18:31 Joanie wpa_supplicant[1135]: wlp3s0: CTRL-EVENT-DISCONNECTED bssid=c0:8a:de:20:2f:68 reason=3 locally_generated=1
Aug  4 08:18:31 Joanie NetworkManager[866]: <info>  [1533385111.4408] dns-mgr: Writing DNS information to /sbin/resolvconf
Aug  4 08:18:31 Joanie avahi-daemon[15386]: Withdrawing address record for 10.10.10.100 on wlp3s0.
Aug  4 08:18:31 Joanie avahi-daemon[15386]: Leaving mDNS multicast group on interface wlp3s0.IPv4 with address 10.10.10.100.
Aug  4 08:18:31 Joanie avahi-daemon[15386]: Interface wlp3s0.IPv4 no longer relevant for mDNS.
Aug  4 08:18:31 Joanie avahi-daemon[15386]: Withdrawing address record for fe80::bf52:2694:756c:4265 on wlp3s0.
Aug  4 08:18:31 Joanie avahi-daemon[15386]: Leaving mDNS multicast group on interface wlp3s0.IPv6 with address fe80::bf52:2694:756c:4265.
Aug  4 08:18:31 Joanie avahi-daemon[15386]: Interface wlp3s0.IPv6 no longer relevant for mDNS.
Aug  4 08:18:31 Joanie dnsmasq[1324]: setting upstream servers from DBus
Aug  4 08:18:31 Joanie org.gtk.vfs.Daemon[1873]: ** (process:3196): WARNING **: Couldn't create directory monitor on smb://x-gnome-default-workgroup/. Error: Operation not supported by backend
Aug  4 08:18:31 Joanie kernel: [8612464.646232] cfg80211: World regulatory domain updated:
Aug  4 08:18:31 Joanie kernel: [8612464.646238] cfg80211:  DFS Master region: unset
Aug  4 08:18:31 Joanie kernel: [8612464.646241] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
Aug  4 08:18:31 Joanie kernel: [8612464.646246] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
Aug  4 08:18:31 Joanie kernel: [8612464.646250] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
Aug  4 08:18:31 Joanie kernel: [8612464.646253] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
Aug  4 08:18:31 Joanie kernel: [8612464.646257] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (N/A)
Aug  4 08:18:31 Joanie kernel: [8612464.646262] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (0 s)
Aug  4 08:18:31 Joanie kernel: [8612464.646265] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
Aug  4 08:18:31 Joanie kernel: [8612464.646268] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
Aug  4 08:18:31 Joanie kernel: [8612464.646272] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
Aug  4 08:18:31 Joanie wpa_supplicant[1135]: wlp3s0: CTRL-EVENT-REGDOM-CHANGE init=CORE type=WORLD
Aug  4 08:18:31 Joanie org.gtk.vfs.Daemon[1873]: ** (process:3196): WARNING **: Couldn't create directory monitor on smb://x-gnome-default-workgroup/. Error: Operation not supported by backend
Aug  4 08:18:31 Joanie NetworkManager[866]: <info>  [1533385111.4625] manager: NetworkManager state is now ASLEEP
Aug  4 08:18:31 Joanie dbus[850]: [system] Activating via systemd: service name='org.freedesktop.nm_dispatcher' unit='dbus-org.freedesktop.nm-dispatcher.service'
Aug  4 08:18:31 Joanie systemd[1]: Starting Network Manager Script Dispatcher Service...
Aug  4 08:18:31 Joanie systemd[1]: Reached target Sleep.
Aug  4 08:18:31 Joanie systemd[1]: Starting Suspend...
Aug  4 08:18:31 Joanie wpa_supplicant[1135]: nl80211: deinit ifname=wlp3s0 disabled_11b_rates=0
Aug  4 08:18:31 Joanie dbus[850]: [system] Successfully activated service 'org.freedesktop.nm_dispatcher'
Aug  4 08:18:31 Joanie systemd[1]: Started Network Manager Script Dispatcher Service.
Aug  4 08:18:31 Joanie nm-dispatcher: req:1 'down' [wlp3s0]: new request (1 scripts)
Aug  4 08:18:31 Joanie nm-dispatcher: req:1 'down' [wlp3s0]: start running ordered scripts...
Aug  4 08:18:32 Joanie ntpd[14595]: Deleting interface #28 wlp3s0, 10.10.10.100#123, interface stats: received=188, sent=191, dropped=0, active_time=1125 secs
Aug  4 08:18:32 Joanie ntpd[14595]: 98.191.213.14 local addr 10.10.10.100 -> <null>
Aug  4 08:18:32 Joanie ntpd[14595]: 129.6.15.30 local addr 10.10.10.100 -> <null>
Aug  4 08:18:32 Joanie ntpd[14595]: 69.89.207.99 local addr 10.10.10.100 -> <null>
Aug  4 08:18:32 Joanie ntpd[14595]: 129.6.15.28 local addr 10.10.10.100 -> <null>
Aug  4 08:18:32 Joanie ntpd[14595]: 216.93.242.12 local addr 10.10.10.100 -> <null>
Aug  4 08:18:32 Joanie ntpd[14595]: 12.167.151.1 local addr 10.10.10.100 -> <null>
Aug  4 08:18:32 Joanie ntpd[14595]: 128.10.19.24 local addr 10.10.10.100 -> <null>
Aug  4 08:18:32 Joanie ntpd[14595]: 162.221.74.15 local addr 10.10.10.100 -> <null>
Aug  4 08:18:32 Joanie ntpd[14595]: 45.56.105.98 local addr 10.10.10.100 -> <null>
Aug  4 08:18:32 Joanie ntpd[14595]: 71.19.144.130 local addr 10.10.10.100 -> <null>
Aug  4 08:18:32 Joanie ntpd[14595]: 108.61.73.244 local addr 10.10.10.100 -> <null>
Aug  4 08:18:32 Joanie ntpd[14595]: 216.229.0.50 local addr 10.10.10.100 -> <null>
Aug  4 08:18:32 Joanie ntpd[14595]: 45.63.11.93 local addr 10.10.10.100 -> <null>
Aug  4 08:18:32 Joanie ntpd[14595]: 91.189.89.198 local addr 10.10.10.100 -> <null>
Aug  4 08:18:32 Joanie ntpd[14595]: 91.189.89.199 local addr 10.10.10.100 -> <null>
Aug  4 08:18:32 Joanie ntpd[14595]: 91.189.94.4 local addr 10.10.10.100 -> <null>
Aug  4 08:18:32 Joanie ntpd[14595]: Deleting interface #29 wlp3s0, fe80::bf52:2694:756c:4265%3#123, interface stats: received=0, sent=0, dropped=0, active_time=1125 secs
Aug  4 08:18:41 Joanie systemd-sleep[13408]: Selected interface 'wlp3s0'
Aug  4 08:18:41 Joanie systemd-sleep[13408]: 'SUSPEND' command timed out.
Aug  4 08:18:41 Joanie systemd-sleep[13410]: /lib/systemd/system-sleep/wpasupplicant failed with error code 254.
Aug  4 08:18:41 Joanie systemd-sleep[13408]: Suspending system...
Aug  4 08:18:41 Joanie kernel: [8612474.709559] PM: Syncing filesystems ... done.
Aug  4 08:18:41 Joanie kernel: [8612474.725641] PM: Preparing system for sleep (mem)
Aug  4 09:02:18 Joanie kernel: [8612474.726296] Freezing user space processes ... (elapsed 0.002 seconds) done.
Aug  4 09:02:18 Joanie kernel: [8612474.728366] Freezing remaining freezable tasks ... (elapsed 0.077 seconds) done.
Aug  4 09:02:18 Joanie kernel: [8612474.805597] PM: Suspending system (mem)
Aug  4 09:02:18 Joanie kernel: [8612474.805676] Suspending console(s) (use no_console_suspend to debug)
Aug  4 09:02:18 Joanie kernel: [8612474.967104] sd 0:0:0:0: [sda] Synchronizing SCSI cache
Aug  4 09:02:18 Joanie kernel: [8612474.967246] sd 0:0:0:0: [sda] Stopping disk
Aug  4 09:02:18 Joanie kernel: [8612475.034007] PM: suspend of devices complete after 228.100 msecs
Aug  4 09:02:18 Joanie kernel: [8612475.049956] PM: late suspend of devices complete after 15.945 msecs
Aug  4 09:02:18 Joanie kernel: [8612475.051329] r8169 0000:09:00.0: System wakeup enabled by ACPI
Aug  4 09:02:18 Joanie kernel: [8612475.051420] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
Aug  4 09:02:18 Joanie kernel: [8612475.051599] ehci-pci 0000:00:1a.0: System wakeup enabled by ACPI
Aug  4 09:02:18 Joanie systemd[1]: Time has been changed
Aug  4 09:02:19 Joanie kernel: [8612475.065957] PM: noirq suspend of devices complete after 15.999 msecs
Aug  4 09:02:19 Joanie kernel: [8612475.066111] ACPI: Preparing to enter system sleep state S3
Aug  4 09:02:19 Joanie kernel: [8612475.253783] ACPI : EC: EC stopped
Aug  4 09:02:19 Joanie kernel: [8612475.253788] PM: Saving platform NVS memory
Aug  4 09:02:19 Joanie kernel: [8612475.253802] ACPI Exception: AE_BAD_PARAMETER, Returned by Handler for [EmbeddedControl] (20150930/evregion-297)
Aug  4 09:02:19 Joanie kernel: [8612475.253817] ACPI Error: Method parse/execution failed [\_SB.PCI0.LPCB.EC._Q26] (Node ffff8801334ba3e8), AE_BAD_PARAMETER (20150930/psparse-542)
Aug  4 09:02:19 Joanie kernel: [8612475.254568] Disabling non-boot CPUs ...
Aug  4 09:02:19 Joanie kernel: [8612475.255926] smpboot: CPU 1 is now offline
Aug  4 09:02:19 Joanie kernel: [8612475.267108] Broke affinity for irq 16
Aug  4 09:02:19 Joanie kernel: [8612475.267120] Broke affinity for irq 23
Aug  4 09:02:19 Joanie kernel: [8612475.267128] Broke affinity for irq 26
Aug  4 09:02:18 Joanie systemd[1806]: Time has been changed
Aug  4 09:02:19 Joanie kernel: [8612475.268175] smpboot: CPU 2 is now offline
Aug  4 09:02:19 Joanie kernel: [8612475.278877] Broke affinity for irq 1
Aug  4 09:02:19 Joanie kernel: [8612475.278888] Broke affinity for irq 9
Aug  4 09:02:19 Joanie kernel: [8612475.278894] Broke affinity for irq 12
Aug  4 09:02:19 Joanie kernel: [8612475.278901] Broke affinity for irq 16
Aug  4 09:02:19 Joanie kernel: [8612475.278911] Broke affinity for irq 23
Aug  4 09:02:19 Joanie kernel: [8612475.278916] Broke affinity for irq 24
Aug  4 09:02:19 Joanie kernel: [8612475.278918] Broke affinity for irq 25
Aug  4 09:02:19 Joanie kernel: [8612475.278920] Broke affinity for irq 26
Aug  4 09:02:19 Joanie kernel: [8612475.278923] Broke affinity for irq 29
Aug  4 09:02:19 Joanie kernel: [8612475.279970] smpboot: CPU 3 is now offline
Aug  4 09:02:18 Joanie systemd[1]: Starting Load/Save RF Kill Switch Status...
Aug  4 09:02:19 Joanie kernel: [8612475.295434] ACPI: Low-level resume complete
Aug  4 09:02:19 Joanie kernel: [8612475.295494] ACPI : EC: EC started
Aug  4 09:02:19 Joanie kernel: [8612475.295495] PM: Restoring platform NVS memory
Aug  4 09:02:19 Joanie kernel: [8612475.296079] Enabling non-boot CPUs ...
Aug  4 09:02:19 Joanie kernel: [8612475.315398] x86: Booting SMP configuration:
Aug  4 09:02:18 Joanie systemd[1]: bluetooth.target: Unit not needed anymore. Stopping.
Aug  4 09:02:19 Joanie kernel: [8612475.315399] smpboot: Booting Node 0 Processor 1 APIC 0x4
Aug  4 09:02:19 Joanie kernel: [8612475.317998]  cache: parent cpu1 should not be sleeping
Aug  4 09:02:19 Joanie kernel: [8612475.318242] CPU1 is up
Aug  4 09:02:19 Joanie kernel: [8612475.335415] smpboot: Booting Node 0 Processor 2 APIC 0x1
Aug  4 09:02:18 Joanie systemd[1]: Stopped target Bluetooth.
Aug  4 09:02:19 Joanie kernel: [8612475.337915]  cache: parent cpu2 should not be sleeping
Aug  4 09:02:19 Joanie kernel: [8612475.338153] CPU2 is up
Aug  4 09:02:19 Joanie kernel: [8612475.351462] smpboot: Booting Node 0 Processor 3 APIC 0x5
Aug  4 09:02:19 Joanie kernel: [8612475.354070]  cache: parent cpu3 should not be sleeping
Aug  4 09:02:19 Joanie kernel: [8612475.354304] CPU3 is up
Aug  4 09:02:18 Joanie bluetoothd[23268]: Failed to obtain handles for "Service Changed" characteristic
Aug  4 09:02:19 Joanie kernel: [8612475.356901] ACPI: Waking up from system sleep state S3
Aug  4 09:02:19 Joanie kernel: [8612475.539669] ehci-pci 0000:00:1a.0: System wakeup disabled by ACPI
Aug  4 09:02:19 Joanie kernel: [8612475.539754] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
Aug  4 09:02:19 Joanie kernel: [8612475.539836] PM: noirq resume of devices complete after 16.544 msecs
Aug  4 09:02:18 Joanie bluetoothd[23268]: Not enough free handles to register service
Aug  4 09:02:19 Joanie kernel: [8612475.541981] PM: early resume of devices complete after 2.124 msecs
Aug  4 09:02:19 Joanie kernel: [8612475.542289] r8169 0000:09:00.0: System wakeup disabled by ACPI
Aug  4 09:02:19 Joanie kernel: [8612475.542531] sd 0:0:0:0: [sda] Starting disk
Aug  4 09:02:19 Joanie kernel: [8612475.596759] r8169 0000:09:00.0 enp9s0: link down
Aug  4 09:02:19 Joanie kernel: [8612475.656557] rtc_cmos 00:02: System wakeup disabled by ACPI
Aug  4 09:02:18 Joanie bluetoothd[23268]: Error adding Link Loss service
Aug  4 09:02:19 Joanie kernel: [8612475.771220] usb 2-1.4: reset high-speed USB device number 3 using ehci-pci
Aug  4 09:02:19 Joanie kernel: [8612475.771239] usb 1-1.3: reset full-speed USB device number 3 using ehci-pci
Aug  4 09:02:19 Joanie kernel: [8612475.879263] ata6: SATA link down (SStatus 0 SControl 300)
Aug  4 09:02:19 Joanie kernel: [8612475.879297] ata5: SATA link down (SStatus 0 SControl 300)
Aug  4 09:02:19 Joanie kernel: [8612475.883220] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Aug  4 09:02:18 Joanie bluetoothd[23268]: Not enough free handles to register service
Aug  4 09:02:19 Joanie kernel: [8612475.883768] ata2.00: unexpected _GTF length (8)
Aug  4 09:02:19 Joanie kernel: [8612475.885333] ata2.00: unexpected _GTF length (8)
Aug  4 09:02:19 Joanie kernel: [8612475.885337] ata2.00: configured for UDMA/100
Aug  4 09:02:19 Joanie kernel: [8612475.935264] usb 1-1.6: reset full-speed USB device number 5 using ehci-pci
Aug  4 09:02:19 Joanie kernel: [8612475.939214] usb 2-1.2: reset high-speed USB device number 7 using ehci-pci
Aug  4 09:02:19 Joanie kernel: [8612476.036430] PM: resume of devices complete after 494.473 msecs
Aug  4 09:02:19 Joanie kernel: [8612476.037013] PM: Finishing wakeup.
Aug  4 09:02:19 Joanie kernel: [8612476.037014] Restarting tasks ... done.
Aug  4 09:02:19 Joanie kernel: [8612476.109376] video LNXVIDEO:01: Restoring backlight state
Aug  4 09:02:19 Joanie kernel: [8612476.671781] psmouse serio4: synaptics: queried max coordinates: x [..5856], y [..4938]
Aug  4 09:02:19 Joanie kernel: [8612476.811519] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug  4 09:02:19 Joanie kernel: [8612476.812561] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
Aug  4 09:02:19 Joanie kernel: [8612476.812565] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
Aug  4 09:02:19 Joanie kernel: [8612476.813240] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
Aug  4 09:02:18 Joanie bluetoothd[23268]: message repeated 2 times: [ Not enough free handles to register service]
Aug  4 09:02:18 Joanie bluetoothd[23268]: Current Time Service could not be registered
Aug  4 09:02:19 Joanie kernel: [8612476.813243] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
Aug  4 09:02:19 Joanie kernel: [8612476.813450] ata1.00: configured for UDMA/133
Aug  4 09:02:18 Joanie systemd[1]: Reached target Bluetooth.
Aug  4 09:02:18 Joanie bluetoothd[23268]: gatt-time-server: Input/output error (5)
Aug  4 09:02:18 Joanie bluetoothd[23268]: Not enough free handles to register service
Aug  4 09:02:18 Joanie bluetoothd[23268]: Not enough free handles to register service
Aug  4 09:02:18 Joanie bluetoothd[23268]: Sap driver initialization failed.
Aug  4 09:02:18 Joanie bluetoothd[23268]: sap-server: Operation not permitted (1)
Aug  4 09:02:18 Joanie systemd[1]: Started Load/Save RF Kill Switch Status.
Aug  4 09:02:18 Joanie systemd-sleep[13408]: System resumed.
Aug  4 09:02:18 Joanie systemd-sleep[13408]: Failed to connect to non-global ctrl_ifname: (nil)  error: No such file or directory
Aug  4 09:02:18 Joanie systemd-sleep[13579]: /lib/systemd/system-sleep/wpasupplicant failed with error code 255.
Aug  4 09:02:19 Joanie console-kit-daemon[5307]: console-kit-daemon[5307]: WARNING: Error waiting for native console 29 activation: Resource temporarily unavailable
Aug  4 09:02:19 Joanie console-kit-daemon[5307]: WARNING: Error waiting for native console 29 activation: Resource temporarily unavailable
Aug  4 09:02:19 Joanie systemd-sleep[13408]: /dev/sda:
Aug  4 09:02:19 Joanie systemd-sleep[13408]:  setting Advanced Power Management level to 0x80 (128)
Aug  4 09:02:19 Joanie systemd-sleep[13408]:  APM_level#011= 128
Aug  4 09:02:19 Joanie systemd-sleep[13408]: /dev/sda:
Aug  4 09:02:19 Joanie systemd-sleep[13408]:  setting standby to 36 (3 minutes)
Aug  4 09:02:19 Joanie systemd[1]: Started Suspend.
Aug  4 09:02:19 Joanie systemd[1]: sleep.target: Unit not needed anymore. Stopping.
Aug  4 09:02:19 Joanie systemd[1]: Stopped target Sleep.
Aug  4 09:02:19 Joanie systemd[1]: Reached target Suspend.
Aug  4 09:02:19 Joanie systemd[1]: suspend.target: Unit is bound to inactive unit systemd-suspend.service. Stopping, too.
Aug  4 09:02:19 Joanie systemd[1]: Stopped target Suspend.
Aug  4 09:02:19 Joanie NetworkManager[866]: <info>  [1533387739.9550] manager: wake requested (sleeping: yes  enabled: yes)
Aug  4 09:02:19 Joanie NetworkManager[866]: <info>  [1533387739.9551] manager: waking up...
Aug  4 09:02:19 Joanie NetworkManager[866]: <info>  [1533387739.9552] device (enp9s0): state change: unavailable -> unmanaged (reason 'sleeping') [20 10 37]
Aug  4 09:02:19 Joanie systemd[1]: Started Run anacron jobs at resume.
Aug  4 09:02:19 Joanie NetworkManager[866]: <info>  [1533387739.9771] device (wlp3s0): state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
Aug  4 09:02:19 Joanie kernel: [8612477.173556] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
Aug  4 09:02:19 Joanie kernel: [8612477.173945] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  4 09:02:19 Joanie kernel: [8612477.181451] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  4 09:02:19 Joanie kernel: [8612477.181552] iwlwifi 0000:03:00.0: Radio type=0x0-0x0-0x3
Aug  4 09:02:20 Joanie kernel: [8612477.216701] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  4 09:02:20 Joanie kernel: [8612477.224214] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  4 09:02:20 Joanie kernel: [8612477.224313] iwlwifi 0000:03:00.0: Radio type=0x0-0x0-0x3
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.0651] device (enp9s0): state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
Aug  4 09:02:20 Joanie kernel: [8612477.259799] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
Aug  4 09:02:20 Joanie kernel: [8612477.261524] IPv6: ADDRCONF(NETDEV_UP): enp9s0: link is not ready
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.1215] manager: NetworkManager state is now DISCONNECTED
Aug  4 09:02:20 Joanie kernel: [8612477.316471] r8169 0000:09:00.0 enp9s0: link down
Aug  4 09:02:20 Joanie kernel: [8612477.316577] IPv6: ADDRCONF(NETDEV_UP): enp9s0: link is not ready
Aug  4 09:02:20 Joanie wpa_supplicant[1135]: dbus: wpa_dbus_get_object_properties: failed to get object properties: (none) none
Aug  4 09:02:20 Joanie wpa_supplicant[1135]: dbus: Failed to construct signal
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.1682] device (wlp3s0): supplicant interface state: starting -> ready
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.1684] device (wlp3s0): state change: unavailable -> disconnected (reason 'supplicant-available') [20 30 42]
Aug  4 09:02:20 Joanie kernel: [8612477.364754] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.6611] device (wlp3s0): supplicant interface state: ready -> inactive
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.6713] policy: auto-activating connection 'VoicePlex'
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.6729] device (wlp3s0): Activation: starting connection 'VoicePlex' (cf0aa26d-621a-4742-bf42-0b0a1644f3ca)
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.6734] device (wlp3s0): state change: disconnected -> prepare (reason 'none') [30 40 0]
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.6738] manager: NetworkManager state is now CONNECTING
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.6751] device (wlp3s0): state change: prepare -> config (reason 'none') [40 50 0]
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.6755] device (wlp3s0): Activation: (wifi) access point 'VoicePlex' has security, but secrets are required.
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.6756] device (wlp3s0): state change: config -> need-auth (reason 'none') [50 60 0]
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.6821] device (wlp3s0): state change: need-auth -> prepare (reason 'none') [60 40 0]
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.6826] device (wlp3s0): state change: prepare -> config (reason 'none') [40 50 0]
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.6829] device (wlp3s0): Activation: (wifi) connection 'VoicePlex' has security, and secrets exist.  No new secrets needed.
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.6831] Config: added 'ssid' value 'VoicePlex'
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.6831] Config: added 'scan_ssid' value '1'
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.6831] Config: added 'key_mgmt' value 'WPA-PSK'
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.6831] Config: added 'auth_alg' value 'OPEN'
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.6832] Config: added 'psk' value '<omitted>'
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.6842] sup-iface[0xb0f430,wlp3s0]: config: set interface ap_scan to 1
Aug  4 09:02:20 Joanie wpa_supplicant[1135]: wlp3s0: SME: Trying to authenticate with c0:8a:de:20:2f:68 (SSID='VoicePlex' freq=2412 MHz)
Aug  4 09:02:20 Joanie kernel: [8612477.893805] wlp3s0: authenticate with c0:8a:de:20:2f:68
Aug  4 09:02:20 Joanie wpa_supplicant[1135]: wlp3s0: Trying to associate with c0:8a:de:20:2f:68 (SSID='VoicePlex' freq=2412 MHz)
Aug  4 09:02:20 Joanie kernel: [8612477.895360] wlp3s0: send auth to c0:8a:de:20:2f:68 (try 1/3)
Aug  4 09:02:20 Joanie kernel: [8612477.896864] wlp3s0: authenticated
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.7034] device (wlp3s0): supplicant interface state: inactive -> associating
Aug  4 09:02:20 Joanie kernel: [8612477.903048] wlp3s0: associate with c0:8a:de:20:2f:68 (try 1/3)
Aug  4 09:02:20 Joanie kernel: [8612477.906975] wlp3s0: RX AssocResp from c0:8a:de:20:2f:68 (capab=0x431 status=0 aid=4)
Aug  4 09:02:20 Joanie wpa_supplicant[1135]: wlp3s0: Associated with c0:8a:de:20:2f:68
Aug  4 09:02:20 Joanie kernel: [8612477.910401] wlp3s0: associated
Aug  4 09:02:20 Joanie kernel: [8612477.910471] IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s0: link becomes ready
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.7206] device (wlp3s0): supplicant interface state: associating -> 4-way handshake
Aug  4 09:02:20 Joanie wpa_supplicant[1135]: wlp3s0: WPA: Key negotiation completed with c0:8a:de:20:2f:68 [PTK=CCMP GTK=CCMP]
Aug  4 09:02:20 Joanie wpa_supplicant[1135]: wlp3s0: CTRL-EVENT-CONNECTED - Connection to c0:8a:de:20:2f:68 completed [id=0 id_str=]
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.7288] device (wlp3s0): supplicant interface state: 4-way handshake -> completed
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.7292] device (wlp3s0): Activation: (wifi) Stage 2 of 5 (Device Configure) successful.  Connected to wireless network 'VoicePlex'.
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.7294] device (wlp3s0): state change: config -> ip-config (reason 'none') [50 70 0]
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.7309] dhcp4 (wlp3s0): activation: beginning transaction (timeout in 45 seconds)
Aug  4 09:02:20 Joanie NetworkManager[866]: <info>  [1533387740.7335] dhcp4 (wlp3s0): dhclient started with pid 13635
Aug  4 09:02:20 Joanie dhclient[13635]: DHCPREQUEST of 10.10.10.100 on wlp3s0 to 255.255.255.255 port 67 (xid=0x20c558de)
Aug  4 09:02:20 Joanie dhclient[13635]: DHCPACK of 10.10.10.100 from 10.10.10.254
Aug  4 09:02:21 Joanie NetworkManager[866]: <info>  [1533387741.1776]   address 10.10.10.100
Aug  4 09:02:21 Joanie NetworkManager[866]: <info>  [1533387741.1777]   plen 24 (255.255.255.0)
Aug  4 09:02:21 Joanie NetworkManager[866]: <info>  [1533387741.1777]   gateway 10.10.10.254
Aug  4 09:02:21 Joanie NetworkManager[866]: <info>  [1533387741.1778]   server identifier 10.10.10.254
Aug  4 09:02:21 Joanie NetworkManager[866]: <info>  [1533387741.1778]   lease time 86400
Aug  4 09:02:21 Joanie NetworkManager[866]: <info>  [1533387741.1778]   hostname 'Joanie'
Aug  4 09:02:21 Joanie NetworkManager[866]: <info>  [1533387741.1779]   nameserver '10.10.10.254'
Aug  4 09:02:21 Joanie NetworkManager[866]: <info>  [1533387741.1779] dhcp4 (wlp3s0): state changed unknown -> bound
Aug  4 09:02:21 Joanie avahi-daemon[15386]: Joining mDNS multicast group on interface wlp3s0.IPv4 with address 10.10.10.100.
Aug  4 09:02:21 Joanie avahi-daemon[15386]: New relevant interface wlp3s0.IPv4 for mDNS.
Aug  4 09:02:21 Joanie avahi-daemon[15386]: Registering new address record for 10.10.10.100 on wlp3s0.IPv4.
Aug  4 09:02:21 Joanie NetworkManager[866]: <info>  [1533387741.1812] device (wlp3s0): state change: ip-config -> ip-check (reason 'none') [70 80 0]
Aug  4 09:02:21 Joanie NetworkManager[866]: <info>  [1533387741.1825] device (wlp3s0): state change: ip-check -> secondaries (reason 'none') [80 90 0]
Aug  4 09:02:21 Joanie NetworkManager[866]: <info>  [1533387741.1833] device (wlp3s0): state change: secondaries -> activated (reason 'none') [90 100 0]
Aug  4 09:02:21 Joanie NetworkManager[866]: <info>  [1533387741.1836] manager: NetworkManager state is now CONNECTED_LOCAL
Aug  4 09:02:21 Joanie dhclient[13635]: bound to 10.10.10.100 -- renewal in 32865 seconds.
Aug  4 09:02:21 Joanie NetworkManager[866]: <info>  [1533387741.1968] manager: NetworkManager state is now CONNECTED_GLOBAL
Aug  4 09:02:21 Joanie NetworkManager[866]: <info>  [1533387741.1969] policy: set 'VoicePlex' (wlp3s0) as default for IPv4 routing and DNS
Aug  4 09:02:21 Joanie NetworkManager[866]: <info>  [1533387741.1972] dns-mgr: Writing DNS information to /sbin/resolvconf
Aug  4 09:02:21 Joanie dnsmasq[1324]: setting upstream servers from DBus
Aug  4 09:02:21 Joanie dnsmasq[1324]: using nameserver 10.10.10.254#53
Aug  4 09:02:21 Joanie NetworkManager[866]: <info>  [1533387741.2083] device (wlp3s0): Activation: successful, device activated.
Aug  4 09:02:21 Joanie dbus[850]: [system] Activating via systemd: service name='org.freedesktop.nm_dispatcher' unit='dbus-org.freedesktop.nm-dispatcher.service'
Aug  4 09:02:21 Joanie systemd[1]: Starting Network Manager Script Dispatcher Service...
Aug  4 09:02:21 Joanie dbus[850]: [system] Successfully activated service 'org.freedesktop.nm_dispatcher'
Aug  4 09:02:21 Joanie systemd[1]: Started Network Manager Script Dispatcher Service.
Aug  4 09:02:21 Joanie nm-dispatcher: req:1 'up' [wlp3s0]: new request (1 scripts)
Aug  4 09:02:21 Joanie nm-dispatcher: req:1 'up' [wlp3s0]: start running ordered scripts...
Aug  4 09:02:21 Joanie org.gtk.vfs.Daemon[1873]: ** (process:3196): WARNING **: Couldn't create directory monitor on smb://x-gnome-default-workgroup/. Error: Operation not supported by backend
Aug  4 09:02:21 Joanie ntpdate[13690]: the NTP socket is in use, exiting
Aug  4 09:02:21 Joanie org.gtk.vfs.Daemon[1873]: ** (process:3196): WARNING **: Couldn't create directory monitor on smb://x-gnome-default-workgroup/. Error: Operation not supported by backend
Aug  4 09:02:21 Joanie org.gtk.vfs.Daemon[1873]: ** (process:3196): WARNING **: Couldn't create directory monitor on smb://x-gnome-default-workgroup/. Error: Operation not supported by backend
Aug  4 09:02:21 Joanie avahi-daemon[15386]: Joining mDNS multicast group on interface wlp3s0.IPv6 with address fe80::bf52:2694:756c:4265.
Aug  4 09:02:21 Joanie avahi-daemon[15386]: New relevant interface wlp3s0.IPv6 for mDNS.
Aug  4 09:02:21 Joanie avahi-daemon[15386]: Registering new address record for fe80::bf52:2694:756c:4265 on wlp3s0.*.
Aug  4 09:02:23 Joanie ntpd[14595]: Listen normally on 30 wlp3s0 10.10.10.100:123
Aug  4 09:02:23 Joanie ntpd[14595]: Listen normally on 31 wlp3s0 [fe80::bf52:2694:756c:4265%3]:123
Aug  4 09:02:23 Joanie ntpd[14595]: new interface(s) found: waking up resolver
Aug  4 09:02:24 Joanie ntpd[14595]: 91.189.94.4 local addr 10.10.10.100 -> <null>
Aug  4 09:02:24 Joanie ntpd[14595]: 91.189.89.198 local addr 10.10.10.100 -> <null>
Aug  4 09:02:28 Joanie ntpd[14595]: 91.189.89.199 local addr 10.10.10.100 -> <null>
Aug  4 09:02:32 Joanie ntpd[14595]: Soliciting pool server 140.82.7.153
Aug  4 09:02:33 Joanie ntpd[14595]: Soliciting pool server 69.164.201.245
Aug  4 09:02:38 Joanie systemd[1806]: Time has been changed
Aug  4 09:02:38 Joanie systemd[1]: Time has been changed
Aug  4 09:02:47 Joanie ntpd[14595]: Soliciting pool server 66.207.226.14
Aug  4 09:12:34 Joanie dbus[850]: [system] Activating via systemd: service name='org.freedesktop.PackageKit' unit='packagekit.service'
Aug  4 09:12:34 Joanie systemd[1]: Starting PackageKit Daemon...
Aug  4 09:12:34 Joanie PackageKit: daemon start
Aug  4 09:12:34 Joanie dbus[850]: [system] Successfully activated service 'org.freedesktop.PackageKit'
Aug  4 09:12:34 Joanie systemd[1]: Started PackageKit Daemon.
Aug  4 09:15:02 Joanie NetworkManager[866]: <info>  [1533388502.8892] manager: sleep requested (sleeping: no  enabled: yes)
Aug  4 09:15:02 Joanie NetworkManager[866]: <info>  [1533388502.8892] manager: sleeping...
Aug  4 09:15:02 Joanie NetworkManager[866]: <info>  [1533388502.8893] device (wlp3s0): state change: activated -> unmanaged (reason 'sleeping') [100 10 37]
Aug  4 09:15:02 Joanie NetworkManager[866]: <info>  [1533388502.9061] dhcp4 (wlp3s0): canceled DHCP transaction, DHCP client pid 13635
Aug  4 09:15:02 Joanie NetworkManager[866]: <info>  [1533388502.9062] dhcp4 (wlp3s0): state changed bound -> done
Aug  4 09:15:02 Joanie kernel: [8613239.681103] wlp3s0: deauthenticating from c0:8a:de:20:2f:68 by local choice (Reason: 3=DEAUTH_LEAVING)
Aug  4 09:15:02 Joanie wpa_supplicant[1135]: wlp3s0: CTRL-EVENT-DISCONNECTED bssid=c0:8a:de:20:2f:68 reason=3 locally_generated=1
Aug  4 09:15:02 Joanie avahi-daemon[15386]: Withdrawing address record for 10.10.10.100 on wlp3s0.
Aug  4 09:15:02 Joanie avahi-daemon[15386]: Leaving mDNS multicast group on interface wlp3s0.IPv4 with address 10.10.10.100.
Aug  4 09:15:02 Joanie avahi-daemon[15386]: Interface wlp3s0.IPv4 no longer relevant for mDNS.
Aug  4 09:15:02 Joanie NetworkManager[866]: <info>  [1533388502.9291] dns-mgr: Writing DNS information to /sbin/resolvconf
Aug  4 09:15:02 Joanie avahi-daemon[15386]: Withdrawing address record for fe80::bf52:2694:756c:4265 on wlp3s0.
Aug  4 09:15:02 Joanie avahi-daemon[15386]: Leaving mDNS multicast group on interface wlp3s0.IPv6 with address fe80::bf52:2694:756c:4265.
Aug  4 09:15:02 Joanie avahi-daemon[15386]: Interface wlp3s0.IPv6 no longer relevant for mDNS.
Aug  4 09:15:02 Joanie dnsmasq[1324]: setting upstream servers from DBus
Aug  4 09:15:02 Joanie org.gtk.vfs.Daemon[1873]: ** (process:3196): WARNING **: Couldn't create directory monitor on smb://x-gnome-default-workgroup/. Error: Operation not supported by backend
Aug  4 09:15:02 Joanie wpa_supplicant[1135]: wlp3s0: CTRL-EVENT-REGDOM-CHANGE init=CORE type=WORLD
Aug  4 09:15:02 Joanie kernel: [8613239.716099] cfg80211: World regulatory domain updated:
Aug  4 09:15:02 Joanie kernel: [8613239.716106] cfg80211:  DFS Master region: unset
Aug  4 09:15:02 Joanie kernel: [8613239.716108] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
Aug  4 09:15:02 Joanie kernel: [8613239.716113] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
Aug  4 09:15:02 Joanie kernel: [8613239.716117] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
Aug  4 09:15:02 Joanie kernel: [8613239.716120] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
Aug  4 09:15:02 Joanie kernel: [8613239.716125] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (N/A)
Aug  4 09:15:02 Joanie kernel: [8613239.716129] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (0 s)
Aug  4 09:15:02 Joanie kernel: [8613239.716133] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
Aug  4 09:15:02 Joanie kernel: [8613239.716136] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
Aug  4 09:15:02 Joanie kernel: [8613239.716140] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
Aug  4 09:15:02 Joanie NetworkManager[866]: <info>  [1533388502.9482] manager: NetworkManager state is now ASLEEP
Aug  4 09:15:02 Joanie dbus[850]: [system] Activating via systemd: service name='org.freedesktop.nm_dispatcher' unit='dbus-org.freedesktop.nm-dispatcher.service'
Aug  4 09:15:02 Joanie systemd[1]: Reached target Sleep.
Aug  4 09:15:03 Joanie systemd[1]: Starting Suspend...
Aug  4 09:15:03 Joanie systemd[1]: Starting Network Manager Script Dispatcher Service...
Aug  4 09:15:03 Joanie wpa_supplicant[1135]: nl80211: deinit ifname=wlp3s0 disabled_11b_rates=0
Aug  4 09:15:03 Joanie dbus[850]: [system] Successfully activated service 'org.freedesktop.nm_dispatcher'
Aug  4 09:15:03 Joanie systemd[1]: Started Network Manager Script Dispatcher Service.
Aug  4 09:15:03 Joanie nm-dispatcher: req:1 'down' [wlp3s0]: new request (1 scripts)
Aug  4 09:15:03 Joanie nm-dispatcher: req:1 'down' [wlp3s0]: start running ordered scripts...
Aug  4 09:15:04 Joanie ntpd[14595]: Deleting interface #30 wlp3s0, 10.10.10.100#123, interface stats: received=198, sent=201, dropped=0, active_time=760 secs
Aug  4 09:15:04 Joanie ntpd[14595]: 66.207.226.14 local addr 10.10.10.100 -> <null>
Aug  4 09:15:04 Joanie ntpd[14595]: 69.164.201.245 local addr 10.10.10.100 -> <null>
Aug  4 09:15:04 Joanie ntpd[14595]: 140.82.7.153 local addr 10.10.10.100 -> <null>
Aug  4 09:15:04 Joanie ntpd[14595]: 98.191.213.14 local addr 10.10.10.100 -> <null>
Aug  4 09:15:04 Joanie ntpd[14595]: 129.6.15.30 local addr 10.10.10.100 -> <null>
Aug  4 09:15:04 Joanie ntpd[14595]: 69.89.207.99 local addr 10.10.10.100 -> <null>
Aug  4 09:15:04 Joanie ntpd[14595]: 129.6.15.28 local addr 10.10.10.100 -> <null>
Aug  4 09:15:04 Joanie ntpd[14595]: 216.93.242.12 local addr 10.10.10.100 -> <null>
Aug  4 09:15:04 Joanie ntpd[14595]: 12.167.151.1 local addr 10.10.10.100 -> <null>
Aug  4 09:15:04 Joanie ntpd[14595]: 128.10.19.24 local addr 10.10.10.100 -> <null>
Aug  4 09:15:04 Joanie ntpd[14595]: 162.221.74.15 local addr 10.10.10.100 -> <null>
Aug  4 09:15:04 Joanie ntpd[14595]: 45.56.105.98 local addr 10.10.10.100 -> <null>
Aug  4 09:15:04 Joanie ntpd[14595]: 71.19.144.130 local addr 10.10.10.100 -> <null>
Aug  4 09:15:04 Joanie ntpd[14595]: 108.61.73.244 local addr 10.10.10.100 -> <null>
Aug  4 09:15:04 Joanie ntpd[14595]: 216.229.0.50 local addr 10.10.10.100 -> <null>
Aug  4 09:15:04 Joanie ntpd[14595]: 45.63.11.93 local addr 10.10.10.100 -> <null>
Aug  4 09:15:04 Joanie ntpd[14595]: Deleting interface #31 wlp3s0, fe80::bf52:2694:756c:4265%3#123, interface stats: received=0, sent=0, dropped=0, active_time=760 secs
Aug  4 09:15:13 Joanie systemd-sleep[14654]: Selected interface 'wlp3s0'
Aug  4 09:15:13 Joanie systemd-sleep[14654]: 'SUSPEND' command timed out.
Aug  4 09:15:13 Joanie systemd-sleep[14659]: /lib/systemd/system-sleep/wpasupplicant failed with error code 254.
Aug  4 09:15:13 Joanie systemd-sleep[14654]: Suspending system...
Aug  4 22:28:32 Joanie kernel: [8613249.792077] PM: Syncing filesystems ... done.
Aug  4 22:28:32 Joanie kernel: [8613249.807855] PM: Preparing system for sleep (mem)
Aug  4 22:28:32 Joanie kernel: [8613249.808204] Freezing user space processes ... (elapsed 0.002 seconds) done.
Aug  4 22:28:32 Joanie kernel: [8613249.810624] Freezing remaining freezable tasks ... (elapsed 0.028 seconds) done.
Aug  4 22:28:32 Joanie kernel: [8613249.839480] PM: Suspending system (mem)
Aug  4 22:28:32 Joanie kernel: [8613249.839558] Suspending console(s) (use no_console_suspend to debug)
Aug  4 22:28:32 Joanie kernel: [8613249.997899] sd 0:0:0:0: [sda] Synchronizing SCSI cache
Aug  4 22:28:32 Joanie kernel: [8613249.998821] sd 0:0:0:0: [sda] Stopping disk
Aug  4 22:28:32 Joanie kernel: [8613250.291487] PM: suspend of devices complete after 451.732 msecs
Aug  4 22:28:32 Joanie kernel: [8613250.307178] PM: late suspend of devices complete after 15.687 msecs
Aug  4 22:28:32 Joanie kernel: [8613250.308503] r8169 0000:09:00.0: System wakeup enabled by ACPI
Aug  4 22:28:32 Joanie kernel: [8613250.308608] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
Aug  4 22:28:32 Joanie kernel: [8613250.308939] ehci-pci 0000:00:1a.0: System wakeup enabled by ACPI
Aug  4 22:28:32 Joanie kernel: [8613250.323285] PM: noirq suspend of devices complete after 16.102 msecs
Aug  4 22:28:32 Joanie kernel: [8613250.323492] ACPI: Preparing to enter system sleep state S3
Aug  4 22:28:32 Joanie kernel: [8613250.511065] ACPI : EC: EC stopped
Aug  4 22:28:32 Joanie kernel: [8613250.511068] PM: Saving platform NVS memory
Aug  4 22:28:32 Joanie kernel: [8613250.512280] Disabling non-boot CPUs ...
Aug  4 22:28:32 Joanie kernel: [8613250.513822] smpboot: CPU 1 is now offline
Aug  4 22:28:32 Joanie kernel: [8613250.524369] Broke affinity for irq 16
Aug  4 22:28:32 Joanie kernel: [8613250.524382] Broke affinity for irq 23
Aug  4 22:28:32 Joanie kernel: [8613250.524390] Broke affinity for irq 26
Aug  4 22:28:32 Joanie kernel: [8613250.525441] smpboot: CPU 2 is now offline
Aug  4 22:28:32 Joanie kernel: [8613250.540131] Broke affinity for irq 1
Aug  4 22:28:32 Joanie kernel: [8613250.540142] Broke affinity for irq 9
Aug  4 22:28:32 Joanie kernel: [8613250.540148] Broke affinity for irq 12
Aug  4 22:28:32 Joanie kernel: [8613250.540155] Broke affinity for irq 16
Aug  4 22:28:32 Joanie kernel: [8613250.540165] Broke affinity for irq 23
Aug  4 22:28:32 Joanie kernel: [8613250.540170] Broke affinity for irq 24
Aug  4 22:28:32 Joanie kernel: [8613250.540172] Broke affinity for irq 25
Aug  4 22:28:32 Joanie kernel: [8613250.540175] Broke affinity for irq 26
Aug  4 22:28:32 Joanie kernel: [8613250.540177] Broke affinity for irq 29
Aug  4 22:28:32 Joanie kernel: [8613250.541221] smpboot: CPU 3 is now offline
Aug  4 22:28:32 Joanie kernel: [8613250.552687] ACPI: Low-level resume complete
Aug  4 22:28:32 Joanie kernel: [8613250.552746] ACPI : EC: EC started
Aug  4 22:28:32 Joanie kernel: [8613250.552747] PM: Restoring platform NVS memory
Aug  4 22:28:32 Joanie kernel: [8613250.553312] Enabling non-boot CPUs ...
Aug  4 22:28:32 Joanie kernel: [8613250.572666] x86: Booting SMP configuration:
Aug  4 22:28:32 Joanie kernel: [8613250.572667] smpboot: Booting Node 0 Processor 1 APIC 0x4
Aug  4 22:28:32 Joanie kernel: [8613250.575271]  cache: parent cpu1 should not be sleeping
Aug  4 22:28:32 Joanie kernel: [8613250.575512] CPU1 is up
Aug  4 22:28:32 Joanie kernel: [8613250.592684] smpboot: Booting Node 0 Processor 2 APIC 0x1
Aug  4 22:28:32 Joanie kernel: [8613250.595183]  cache: parent cpu2 should not be sleeping
Aug  4 22:28:32 Joanie kernel: [8613250.595422] CPU2 is up
Aug  4 22:28:32 Joanie kernel: [8613250.608734] smpboot: Booting Node 0 Processor 3 APIC 0x5
Aug  4 22:28:32 Joanie kernel: [8613250.611249]  cache: parent cpu3 should not be sleeping
Aug  4 22:28:32 Joanie kernel: [8613250.611491] CPU3 is up
Aug  4 22:28:32 Joanie kernel: [8613250.614072] ACPI: Waking up from system sleep state S3
Aug  4 22:28:32 Joanie kernel: [8613250.796957] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
Aug  4 22:28:32 Joanie kernel: [8613250.796988] ehci-pci 0000:00:1a.0: System wakeup disabled by ACPI
Aug  4 22:28:32 Joanie kernel: [8613250.797120] PM: noirq resume of devices complete after 16.553 msecs
Aug  4 22:28:32 Joanie kernel: [8613250.799279] PM: early resume of devices complete after 2.138 msecs
Aug  4 22:28:32 Joanie kernel: [8613250.799592] r8169 0000:09:00.0: System wakeup disabled by ACPI
Aug  4 22:28:32 Joanie kernel: [8613250.804891] sd 0:0:0:0: [sda] Starting disk
Aug  4 22:28:32 Joanie kernel: [8613250.853961] r8169 0000:09:00.0 enp9s0: link down
Aug  4 22:28:32 Joanie kernel: [8613250.913560] rtc_cmos 00:02: System wakeup disabled by ACPI
Aug  4 22:28:32 Joanie kernel: [8613251.028509] usb 1-1.3: reset full-speed USB device number 3 using ehci-pci
Aug  4 22:28:32 Joanie kernel: [8613251.032540] usb 2-1.2: reset high-speed USB device number 7 using ehci-pci
Aug  4 22:28:32 Joanie kernel: [8613251.136495] ata5: SATA link down (SStatus 0 SControl 300)
Aug  4 22:28:32 Joanie kernel: [8613251.136533] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Aug  4 22:28:32 Joanie kernel: [8613251.137115] ata2.00: unexpected _GTF length (8)
Aug  4 22:28:32 Joanie kernel: [8613251.138575] ata2.00: unexpected _GTF length (8)
Aug  4 22:28:32 Joanie kernel: [8613251.138579] ata2.00: configured for UDMA/100
Aug  4 22:28:32 Joanie kernel: [8613251.144507] ata6: SATA link down (SStatus 0 SControl 300)
Aug  4 22:28:32 Joanie kernel: [8613251.192509] usb 1-1.6: reset full-speed USB device number 5 using ehci-pci
Aug  4 22:28:32 Joanie kernel: [8613251.196467] usb 2-1.4: reset high-speed USB device number 3 using ehci-pci
Aug  4 22:28:32 Joanie kernel: [8613251.297018] PM: resume of devices complete after 497.762 msecs
Aug  4 22:28:32 Joanie kernel: [8613251.297626] PM: Finishing wakeup.
Aug  4 22:28:32 Joanie systemd[1]: Time has been changed
Aug  4 22:28:32 Joanie systemd[1806]: Time has been changed
Aug  4 22:28:32 Joanie kernel: [8613251.297628] Restarting tasks ... done.
Aug  4 22:28:32 Joanie bluetoothd[23268]: Failed to obtain handles for "Service Changed" characteristic
Aug  4 22:28:32 Joanie bluetoothd[23268]: Not enough free handles to register service
Aug  4 22:28:32 Joanie bluetoothd[23268]: Error adding Link Loss service
Aug  4 22:28:32 Joanie bluetoothd[23268]: Not enough free handles to register service
Aug  4 22:28:32 Joanie bluetoothd[23268]: message repeated 2 times: [ Not enough free handles to register service]
Aug  4 22:28:32 Joanie bluetoothd[23268]: Current Time Service could not be registered
Aug  4 22:28:32 Joanie bluetoothd[23268]: gatt-time-server: Input/output error (5)
Aug  4 22:28:32 Joanie bluetoothd[23268]: Not enough free handles to register service
Aug  4 22:28:32 Joanie bluetoothd[23268]: Not enough free handles to register service
Aug  4 22:28:32 Joanie bluetoothd[23268]: Sap driver initialization failed.
Aug  4 22:28:32 Joanie bluetoothd[23268]: sap-server: Operation not permitted (1)
Aug  4 22:28:32 Joanie kernel: [8613251.377309] video LNXVIDEO:01: Restoring backlight state
Aug  4 22:28:32 Joanie systemd-sleep[14654]: System resumed.
Aug  4 22:28:32 Joanie systemd-sleep[14654]: Failed to connect to non-global ctrl_ifname: (nil)  error: No such file or directory
Aug  4 22:28:32 Joanie systemd[1]: Starting Load/Save RF Kill Switch Status...
Aug  4 22:28:32 Joanie systemd[1]: Started Load/Save RF Kill Switch Status.
Aug  4 22:28:32 Joanie systemd[1]: bluetooth.target: Unit not needed anymore. Stopping.
Aug  4 22:28:32 Joanie systemd[1]: Stopped target Bluetooth.
Aug  4 22:28:33 Joanie kernel: [8613251.930703] psmouse serio4: synaptics: queried max coordinates: x [..5856], y [..4938]
Aug  4 22:28:33 Joanie kernel: [8613252.076446] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug  4 22:28:33 Joanie kernel: [8613252.085838] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
Aug  4 22:28:33 Joanie kernel: [8613252.085841] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
Aug  4 22:28:33 Joanie kernel: [8613252.086477] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
Aug  4 22:28:33 Joanie kernel: [8613252.086481] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
Aug  4 22:28:33 Joanie kernel: [8613252.086686] ata1.00: configured for UDMA/133
Aug  4 22:28:33 Joanie systemd-sleep[14654]: /dev/sda:
Aug  4 22:28:33 Joanie systemd-sleep[14654]:  setting Advanced Power Management level to 0x80 (128)
Aug  4 22:28:33 Joanie systemd-sleep[14654]:  APM_level#011= 128
Aug  4 22:28:33 Joanie systemd-sleep[14654]: /dev/sda:
Aug  4 22:28:33 Joanie systemd-sleep[14654]:  setting standby to 36 (3 minutes)
Aug  4 22:28:33 Joanie systemd-sleep[14810]: /lib/systemd/system-sleep/wpasupplicant failed with error code 255.
Aug  4 22:28:33 Joanie systemd[1]: Started Suspend.
Aug  4 22:28:33 Joanie systemd[1]: sleep.target: Unit not needed anymore. Stopping.
Aug  4 22:28:33 Joanie systemd[1]: Stopped target Sleep.
Aug  4 22:28:33 Joanie systemd[1]: Reached target Suspend.
Aug  4 22:28:33 Joanie systemd[1]: suspend.target: Unit is bound to inactive unit systemd-suspend.service. Stopping, too.
Aug  4 22:28:33 Joanie systemd[1]: Stopped target Suspend.
Aug  4 22:28:33 Joanie NetworkManager[866]: <info>  [1533436113.9884] manager: wake requested (sleeping: yes  enabled: yes)
Aug  4 22:28:34 Joanie kernel: [8613252.458810] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
Aug  4 22:28:34 Joanie kernel: [8613252.459001] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436113.9884] manager: waking up...
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436113.9885] device (enp9s0): state change: unavailable -> unmanaged (reason 'sleeping') [20 10 37]
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.0051] device (wlp3s0): state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
Aug  4 22:28:34 Joanie systemd[1]: Started Run anacron jobs at resume.
Aug  4 22:28:34 Joanie kernel: [8613252.466674] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  4 22:28:34 Joanie kernel: [8613252.466775] iwlwifi 0000:03:00.0: Radio type=0x0-0x0-0x3
Aug  4 22:28:34 Joanie kernel: [8613252.502044] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  4 22:28:34 Joanie kernel: [8613252.509547] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  4 22:28:34 Joanie kernel: [8613252.509647] iwlwifi 0000:03:00.0: Radio type=0x0-0x0-0x3
Aug  4 22:28:34 Joanie kernel: [8613252.543423] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.0916] device (enp9s0): state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
Aug  4 22:28:34 Joanie kernel: [8613252.545323] IPv6: ADDRCONF(NETDEV_UP): enp9s0: link is not ready
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.1500] manager: NetworkManager state is now DISCONNECTED
Aug  4 22:28:34 Joanie kernel: [8613252.601835] r8169 0000:09:00.0 enp9s0: link down
Aug  4 22:28:34 Joanie kernel: [8613252.601931] IPv6: ADDRCONF(NETDEV_UP): enp9s0: link is not ready
Aug  4 22:28:34 Joanie wpa_supplicant[1135]: dbus: wpa_dbus_get_object_properties: failed to get object properties: (none) none
Aug  4 22:28:34 Joanie wpa_supplicant[1135]: dbus: Failed to construct signal
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.2057] device (wlp3s0): supplicant interface state: starting -> ready
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.2059] device (wlp3s0): state change: unavailable -> disconnected (reason 'supplicant-available') [20 30 42]
Aug  4 22:28:34 Joanie kernel: [8613252.659783] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6295] device (wlp3s0): supplicant interface state: ready -> inactive
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6313] policy: auto-activating connection 'VoicePlex'
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6341] device (wlp3s0): Activation: starting connection 'VoicePlex' (cf0aa26d-621a-4742-bf42-0b0a1644f3ca)
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6345] device (wlp3s0): state change: disconnected -> prepare (reason 'none') [30 40 0]
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6349] manager: NetworkManager state is now CONNECTING
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6360] device (wlp3s0): state change: prepare -> config (reason 'none') [40 50 0]
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6364] device (wlp3s0): Activation: (wifi) access point 'VoicePlex' has security, but secrets are required.
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6364] device (wlp3s0): state change: config -> need-auth (reason 'none') [50 60 0]
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6428] device (wlp3s0): state change: need-auth -> prepare (reason 'none') [60 40 0]
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6434] device (wlp3s0): state change: prepare -> config (reason 'none') [40 50 0]
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6438] device (wlp3s0): Activation: (wifi) connection 'VoicePlex' has security, and secrets exist.  No new secrets needed.
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6438] Config: added 'ssid' value 'VoicePlex'
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6439] Config: added 'scan_ssid' value '1'
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6439] Config: added 'key_mgmt' value 'WPA-PSK'
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6439] Config: added 'auth_alg' value 'OPEN'
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6439] Config: added 'psk' value '<omitted>'
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6457] sup-iface[0xb0f590,wlp3s0]: config: set interface ap_scan to 1
Aug  4 22:28:34 Joanie wpa_supplicant[1135]: wlp3s0: SME: Trying to authenticate with c0:8a:de:20:2f:68 (SSID='VoicePlex' freq=2412 MHz)
Aug  4 22:28:34 Joanie kernel: [8613253.108894] wlp3s0: authenticate with c0:8a:de:20:2f:68
Aug  4 22:28:34 Joanie kernel: [8613253.110490] wlp3s0: send auth to c0:8a:de:20:2f:68 (try 1/3)
Aug  4 22:28:34 Joanie kernel: [8613253.112016] wlp3s0: authenticated
Aug  4 22:28:34 Joanie wpa_supplicant[1135]: wlp3s0: Trying to associate with c0:8a:de:20:2f:68 (SSID='VoicePlex' freq=2412 MHz)
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6612] device (wlp3s0): supplicant interface state: inactive -> associating
Aug  4 22:28:34 Joanie kernel: [8613253.112526] wlp3s0: associate with c0:8a:de:20:2f:68 (try 1/3)
Aug  4 22:28:34 Joanie kernel: [8613253.116490] wlp3s0: RX AssocResp from c0:8a:de:20:2f:68 (capab=0x431 status=0 aid=3)
Aug  4 22:28:34 Joanie wpa_supplicant[1135]: wlp3s0: Associated with c0:8a:de:20:2f:68
Aug  4 22:28:34 Joanie kernel: [8613253.120936] wlp3s0: associated
Aug  4 22:28:34 Joanie kernel: [8613253.121031] IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s0: link becomes ready
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6735] device (wlp3s0): supplicant interface state: associating -> 4-way handshake
Aug  4 22:28:34 Joanie wpa_supplicant[1135]: wlp3s0: WPA: Key negotiation completed with c0:8a:de:20:2f:68 [PTK=CCMP GTK=CCMP]
Aug  4 22:28:34 Joanie wpa_supplicant[1135]: wlp3s0: CTRL-EVENT-CONNECTED - Connection to c0:8a:de:20:2f:68 completed [id=0 id_str=]
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6809] device (wlp3s0): supplicant interface state: 4-way handshake -> completed
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6810] device (wlp3s0): Activation: (wifi) Stage 2 of 5 (Device Configure) successful.  Connected to wireless network 'VoicePlex'.
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6811] device (wlp3s0): state change: config -> ip-config (reason 'none') [50 70 0]
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6818] dhcp4 (wlp3s0): activation: beginning transaction (timeout in 45 seconds)
Aug  4 22:28:34 Joanie NetworkManager[866]: <info>  [1533436114.6849] dhcp4 (wlp3s0): dhclient started with pid 14868
Aug  4 22:28:34 Joanie dhclient[14868]: DHCPREQUEST of 10.10.10.100 on wlp3s0 to 255.255.255.255 port 67 (xid=0x32d8816e)
Aug  4 22:28:34 Joanie dhclient[14868]: DHCPACK of 10.10.10.100 from 10.10.10.254
Aug  4 22:28:35 Joanie NetworkManager[866]: <info>  [1533436115.1392]   address 10.10.10.100
Aug  4 22:28:35 Joanie NetworkManager[866]: <info>  [1533436115.1393]   plen 24 (255.255.255.0)
Aug  4 22:28:35 Joanie NetworkManager[866]: <info>  [1533436115.1393]   gateway 10.10.10.254
Aug  4 22:28:35 Joanie NetworkManager[866]: <info>  [1533436115.1394]   server identifier 10.10.10.254
Aug  4 22:28:35 Joanie NetworkManager[866]: <info>  [1533436115.1394]   lease time 86400
Aug  4 22:28:35 Joanie NetworkManager[866]: <info>  [1533436115.1395]   hostname 'Joanie'
Aug  4 22:28:35 Joanie NetworkManager[866]: <info>  [1533436115.1395]   nameserver '10.10.10.254'
Aug  4 22:28:35 Joanie NetworkManager[866]: <info>  [1533436115.1396] dhcp4 (wlp3s0): state changed unknown -> bound
Aug  4 22:28:35 Joanie avahi-daemon[15386]: Joining mDNS multicast group on interface wlp3s0.IPv4 with address 10.10.10.100.
Aug  4 22:28:35 Joanie avahi-daemon[15386]: New relevant interface wlp3s0.IPv4 for mDNS.
Aug  4 22:28:35 Joanie avahi-daemon[15386]: Registering new address record for 10.10.10.100 on wlp3s0.IPv4.
Aug  4 22:28:35 Joanie dhclient[14868]: bound to 10.10.10.100 -- renewal in 34972 seconds.
Aug  4 22:28:35 Joanie NetworkManager[866]: <info>  [1533436115.1454] device (wlp3s0): state change: ip-config -> ip-check (reason 'none') [70 80 0]
Aug  4 22:28:35 Joanie NetworkManager[866]: <info>  [1533436115.1464] device (wlp3s0): state change: ip-check -> secondaries (reason 'none') [80 90 0]
Aug  4 22:28:35 Joanie NetworkManager[866]: <info>  [1533436115.1472] device (wlp3s0): state change: secondaries -> activated (reason 'none') [90 100 0]
Aug  4 22:28:35 Joanie NetworkManager[866]: <info>  [1533436115.1527] manager: NetworkManager state is now CONNECTED_LOCAL
Aug  4 22:28:35 Joanie NetworkManager[866]: <info>  [1533436115.1591] manager: NetworkManager state is now CONNECTED_GLOBAL
Aug  4 22:28:35 Joanie NetworkManager[866]: <info>  [1533436115.1594] policy: set 'VoicePlex' (wlp3s0) as default for IPv4 routing and DNS
Aug  4 22:28:35 Joanie NetworkManager[866]: <info>  [1533436115.1597] dns-mgr: Writing DNS information to /sbin/resolvconf
Aug  4 22:28:35 Joanie dnsmasq[1324]: setting upstream servers from DBus
Aug  4 22:28:35 Joanie dnsmasq[1324]: using nameserver 10.10.10.254#53
Aug  4 22:28:35 Joanie NetworkManager[866]: <info>  [1533436115.1704] device (wlp3s0): Activation: successful, device activated.
Aug  4 22:28:35 Joanie dbus[850]: [system] Activating via systemd: service name='org.freedesktop.nm_dispatcher' unit='dbus-org.freedesktop.nm-dispatcher.service'
Aug  4 22:28:35 Joanie systemd[1]: Starting Network Manager Script Dispatcher Service...
Aug  4 22:28:35 Joanie dbus[850]: [system] Successfully activated service 'org.freedesktop.nm_dispatcher'
Aug  4 22:28:35 Joanie systemd[1]: Started Network Manager Script Dispatcher Service.
Aug  4 22:28:35 Joanie nm-dispatcher: req:1 'up' [wlp3s0]: new request (1 scripts)
Aug  4 22:28:35 Joanie nm-dispatcher: req:1 'up' [wlp3s0]: start running ordered scripts...
Aug  4 22:28:35 Joanie org.gtk.vfs.Daemon[1873]: ** (process:3196): WARNING **: Couldn't create directory monitor on smb://x-gnome-default-workgroup/. Error: Operation not supported by backend
Aug  4 22:28:35 Joanie ntpdate[14924]: the NTP socket is in use, exiting
Aug  4 22:28:35 Joanie org.gtk.vfs.Daemon[1873]: ** (process:3196): WARNING **: Couldn't create directory monitor on smb://x-gnome-default-workgroup/. Error: Operation not supported by backend
Aug  4 22:28:36 Joanie avahi-daemon[15386]: Joining mDNS multicast group on interface wlp3s0.IPv6 with address fe80::bf52:2694:756c:4265.
Aug  4 22:28:36 Joanie avahi-daemon[15386]: New relevant interface wlp3s0.IPv6 for mDNS.
Aug  4 22:28:36 Joanie avahi-daemon[15386]: Registering new address record for fe80::bf52:2694:756c:4265 on wlp3s0.*.
Aug  4 22:28:37 Joanie ntpd[14595]: Listen normally on 32 wlp3s0 10.10.10.100:123
Aug  4 22:28:37 Joanie ntpd[14595]: Listen normally on 33 wlp3s0 [fe80::bf52:2694:756c:4265%3]:123
Aug  4 22:28:37 Joanie ntpd[14595]: new interface(s) found: waking up resolver
Aug  4 22:28:38 Joanie ntpd[14595]: 71.19.144.130 local addr 10.10.10.100 -> <null>
Aug  4 22:30:55 Joanie ntpd[14595]: 69.89.207.99 local addr 10.10.10.100 -> <null>
Aug  4 22:30:57 Joanie PackageKit: daemon quit
Aug  4 22:30:57 Joanie packagekitd[14596]: (packagekitd:14596): GLib-CRITICAL **: Source ID 9 was not found when attempting to remove it
Aug  4 22:43:11 Joanie kernel: [8614129.796881] usb 1-1.1: new high-speed USB device number 12 using ehci-pci
Aug  4 22:43:11 Joanie kernel: [8614129.895560] usb 1-1.1: New USB device found, idVendor=090c, idProduct=1000
Aug  4 22:43:11 Joanie kernel: [8614129.895569] usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Aug  4 22:43:11 Joanie kernel: [8614129.895575] usb 1-1.1: Product: Flash Drive
Aug  4 22:43:11 Joanie kernel: [8614129.895580] usb 1-1.1: Manufacturer: Samsung
Aug  4 22:43:11 Joanie kernel: [8614129.895585] usb 1-1.1: SerialNumber: 0375717070007140
Aug  4 22:43:11 Joanie kernel: [8614129.898349] usb-storage 1-1.1:1.0: USB Mass Storage device detected
Aug  4 22:43:11 Joanie kernel: [8614129.898652] scsi host13: usb-storage 1-1.1:1.0
Aug  4 22:43:11 Joanie mtp-probe: checking bus 1, device 12: "/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.1"
Aug  4 22:43:11 Joanie mtp-probe: bus: 1, device: 12 was not an MTP device
Aug  4 22:43:11 Joanie kernel: [8614130.109311] usb 1-1.1: USB disconnect, device number 12
Aug  4 22:43:12 Joanie kernel: [8614130.820799] usb 1-1.1: new high-speed USB device number 13 using ehci-pci
Aug  4 22:43:12 Joanie kernel: [8614130.919468] usb 1-1.1: New USB device found, idVendor=090c, idProduct=1000
Aug  4 22:43:12 Joanie kernel: [8614130.919478] usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Aug  4 22:43:12 Joanie kernel: [8614130.919483] usb 1-1.1: Product: Flash Drive
Aug  4 22:43:12 Joanie kernel: [8614130.919488] usb 1-1.1: Manufacturer: Samsung
Aug  4 22:43:12 Joanie kernel: [8614130.919493] usb 1-1.1: SerialNumber: 0375717070007140
Aug  4 22:43:12 Joanie kernel: [8614130.920857] usb-storage 1-1.1:1.0: USB Mass Storage device detected
Aug  4 22:43:12 Joanie kernel: [8614130.922186] scsi host14: usb-storage 1-1.1:1.0
Aug  4 22:43:12 Joanie mtp-probe: checking bus 1, device 13: "/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.1"
Aug  4 22:43:12 Joanie mtp-probe: bus: 1, device: 13 was not an MTP device
Aug  4 22:43:13 Joanie kernel: [8614132.140749] scsi 14:0:0:0: Direct-Access     Samsung  Flash Drive      1100 PQ: 0 ANSI: 6
Aug  4 22:43:13 Joanie kernel: [8614132.141428] sd 14:0:0:0: Attached scsi generic sg2 type 0
Aug  4 22:43:13 Joanie kernel: [8614132.142361] sd 14:0:0:0: [sdb] 62668800 512-byte logical blocks: (32.1 GB/29.9 GiB)
Aug  4 22:43:13 Joanie kernel: [8614132.143385] sd 14:0:0:0: [sdb] Write Protect is off
Aug  4 22:43:13 Joanie kernel: [8614132.143395] sd 14:0:0:0: [sdb] Mode Sense: 43 00 00 00
Aug  4 22:43:13 Joanie kernel: [8614132.144506] sd 14:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Aug  4 22:43:13 Joanie kernel: [8614132.154437]  sdb: sdb1
Aug  4 22:43:13 Joanie kernel: [8614132.158770] sd 14:0:0:0: [sdb] Attached SCSI removable disk
Aug  4 22:44:11 Joanie udisksd[2007]: Mounted /dev/sdb1 at /media/dkosek/Samsung USB on behalf of uid 1000
Aug  4 22:44:39 Joanie udisksd[2007]: Cleaning up mount point /media/dkosek/Samsung USB (device 8:17 is not mounted)
Aug  4 22:44:39 Joanie udisksd[2007]: Unmounted /dev/sdb1 on behalf of uid 1000
Aug  4 22:44:43 Joanie kernel: [8614221.751597] usb 1-1.1: USB disconnect, device number 13
Aug  4 22:44:49 Joanie NetworkManager[866]: <info>  [1533437089.3371] manager: sleep requested (sleeping: no  enabled: yes)
Aug  4 22:44:49 Joanie NetworkManager[866]: <info>  [1533437089.3371] manager: sleeping...
Aug  4 22:44:49 Joanie NetworkManager[866]: <info>  [1533437089.3372] device (wlp3s0): state change: activated -> unmanaged (reason 'sleeping') [100 10 37]
Aug  4 22:44:49 Joanie NetworkManager[866]: <info>  [1533437089.3697] dhcp4 (wlp3s0): canceled DHCP transaction, DHCP client pid 14868
Aug  4 22:44:49 Joanie NetworkManager[866]: <info>  [1533437089.3697] dhcp4 (wlp3s0): state changed bound -> done
Aug  4 22:44:49 Joanie kernel: [8614227.753656] wlp3s0: deauthenticating from c0:8a:de:20:2f:68 by local choice (Reason: 3=DEAUTH_LEAVING)
Aug  4 22:44:49 Joanie wpa_supplicant[1135]: wlp3s0: CTRL-EVENT-DISCONNECTED bssid=c0:8a:de:20:2f:68 reason=3 locally_generated=1
Aug  4 22:44:49 Joanie avahi-daemon[15386]: Withdrawing address record for 10.10.10.100 on wlp3s0.
Aug  4 22:44:49 Joanie avahi-daemon[15386]: Leaving mDNS multicast group on interface wlp3s0.IPv4 with address 10.10.10.100.
Aug  4 22:44:49 Joanie avahi-daemon[15386]: Interface wlp3s0.IPv4 no longer relevant for mDNS.
Aug  4 22:44:49 Joanie NetworkManager[866]: <info>  [1533437089.3852] dns-mgr: Writing DNS information to /sbin/resolvconf
Aug  4 22:44:49 Joanie avahi-daemon[15386]: Withdrawing address record for fe80::bf52:2694:756c:4265 on wlp3s0.
Aug  4 22:44:49 Joanie avahi-daemon[15386]: Leaving mDNS multicast group on interface wlp3s0.IPv6 with address fe80::bf52:2694:756c:4265.
Aug  4 22:44:49 Joanie avahi-daemon[15386]: Interface wlp3s0.IPv6 no longer relevant for mDNS.
Aug  4 22:44:49 Joanie dnsmasq[1324]: setting upstream servers from DBus
Aug  4 22:44:49 Joanie kernel: [8614227.776650] cfg80211: World regulatory domain updated:
Aug  4 22:44:49 Joanie kernel: [8614227.776660] cfg80211:  DFS Master region: unset
Aug  4 22:44:49 Joanie kernel: [8614227.776663] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
Aug  4 22:44:49 Joanie kernel: [8614227.776669] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
Aug  4 22:44:49 Joanie kernel: [8614227.776673] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
Aug  4 22:44:49 Joanie kernel: [8614227.776677] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
Aug  4 22:44:49 Joanie kernel: [8614227.776683] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (N/A)
Aug  4 22:44:49 Joanie kernel: [8614227.776688] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (0 s)
Aug  4 22:44:49 Joanie kernel: [8614227.776693] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
Aug  4 22:44:49 Joanie kernel: [8614227.776698] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
Aug  4 22:44:49 Joanie kernel: [8614227.776702] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
Aug  4 22:44:49 Joanie wpa_supplicant[1135]: wlp3s0: CTRL-EVENT-REGDOM-CHANGE init=CORE type=WORLD
Aug  4 22:44:49 Joanie org.gtk.vfs.Daemon[1873]: ** (process:3196): WARNING **: Couldn't create directory monitor on smb://x-gnome-default-workgroup/. Error: Operation not supported by backend
Aug  4 22:44:49 Joanie org.gtk.vfs.Daemon[1873]: ** (process:3196): WARNING **: Couldn't create directory monitor on smb://x-gnome-default-workgroup/. Error: Operation not supported by backend
Aug  4 22:44:49 Joanie NetworkManager[866]: <info>  [1533437089.4076] manager: NetworkManager state is now ASLEEP
Aug  4 22:44:49 Joanie systemd[1]: Reached target Sleep.
Aug  4 22:44:49 Joanie dbus[850]: [system] Activating via systemd: service name='org.freedesktop.nm_dispatcher' unit='dbus-org.freedesktop.nm-dispatcher.service'
Aug  4 22:44:49 Joanie systemd[1]: Starting Suspend...
Aug  4 22:44:49 Joanie systemd[1]: Starting Network Manager Script Dispatcher Service...
Aug  4 22:44:49 Joanie wpa_supplicant[1135]: nl80211: deinit ifname=wlp3s0 disabled_11b_rates=0
Aug  4 22:44:49 Joanie dbus[850]: [system] Successfully activated service 'org.freedesktop.nm_dispatcher'
Aug  4 22:44:49 Joanie systemd[1]: Started Network Manager Script Dispatcher Service.
Aug  4 22:44:49 Joanie nm-dispatcher: req:1 'down' [wlp3s0]: new request (1 scripts)
Aug  4 22:44:49 Joanie nm-dispatcher: req:1 'down' [wlp3s0]: start running ordered scripts...
Aug  4 22:44:50 Joanie ntpd[14595]: Deleting interface #32 wlp3s0, 10.10.10.100#123, interface stats: received=115, sent=115, dropped=0, active_time=973 secs
Aug  4 22:44:50 Joanie ntpd[14595]: 98.191.213.14 local addr 10.10.10.100 -> <null>
Aug  4 22:44:50 Joanie ntpd[14595]: 129.6.15.30 local addr 10.10.10.100 -> <null>
Aug  4 22:44:50 Joanie ntpd[14595]: 129.6.15.28 local addr 10.10.10.100 -> <null>
Aug  4 22:44:50 Joanie ntpd[14595]: 216.93.242.12 local addr 10.10.10.100 -> <null>
Aug  4 22:44:50 Joanie ntpd[14595]: 12.167.151.1 local addr 10.10.10.100 -> <null>
Aug  4 22:44:50 Joanie ntpd[14595]: 128.10.19.24 local addr 10.10.10.100 -> <null>
Aug  4 22:44:50 Joanie ntpd[14595]: 162.221.74.15 local addr 10.10.10.100 -> <null>
Aug  4 22:44:50 Joanie ntpd[14595]: 45.56.105.98 local addr 10.10.10.100 -> <null>
Aug  4 22:44:50 Joanie ntpd[14595]: 108.61.73.244 local addr 10.10.10.100 -> <null>
Aug  4 22:44:50 Joanie ntpd[14595]: 216.229.0.50 local addr 10.10.10.100 -> <null>
Aug  4 22:44:50 Joanie ntpd[14595]: 45.63.11.93 local addr 10.10.10.100 -> <null>
Aug  4 22:44:50 Joanie ntpd[14595]: 140.82.7.153 local addr 10.10.10.100 -> <null>
Aug  4 22:44:50 Joanie ntpd[14595]: 69.164.201.245 local addr 10.10.10.100 -> <null>
Aug  4 22:44:50 Joanie ntpd[14595]: 66.207.226.14 local addr 10.10.10.100 -> <null>
Aug  4 22:44:50 Joanie ntpd[14595]: Deleting interface #33 wlp3s0, fe80::bf52:2694:756c:4265%3#123, interface stats: received=0, sent=0, dropped=0, active_time=973 secs
Aug  4 22:44:59 Joanie systemd-sleep[15599]: Selected interface 'wlp3s0'
Aug  4 22:44:59 Joanie systemd-sleep[15599]: 'SUSPEND' command timed out.
Aug  4 22:44:59 Joanie systemd-sleep[15603]: /lib/systemd/system-sleep/wpasupplicant failed with error code 254.
Aug  4 22:44:59 Joanie systemd-sleep[15599]: Suspending system...
Aug  5 16:07:46 Joanie kernel: [8614237.839865] PM: Syncing filesystems ... done.
Aug  5 16:07:46 Joanie kernel: [8614237.853599] PM: Preparing system for sleep (mem)
Aug  5 16:07:46 Joanie kernel: [8614237.853884] Freezing user space processes ... (elapsed 0.002 seconds) done.
Aug  5 16:07:46 Joanie kernel: [8614237.855968] Freezing remaining freezable tasks ... (elapsed 0.089 seconds) done.
Aug  5 16:07:46 Joanie kernel: [8614237.945332] PM: Suspending system (mem)
Aug  5 16:07:46 Joanie kernel: [8614237.945420] Suspending console(s) (use no_console_suspend to debug)
Aug  5 16:07:46 Joanie kernel: [8614238.108362] sd 0:0:0:0: [sda] Synchronizing SCSI cache
Aug  5 16:07:46 Joanie kernel: [8614238.109165] sd 0:0:0:0: [sda] Stopping disk
Aug  5 16:07:46 Joanie kernel: [8614238.389141] PM: suspend of devices complete after 443.531 msecs
Aug  5 16:07:46 Joanie kernel: [8614238.405219] PM: late suspend of devices complete after 16.073 msecs
Aug  5 16:07:46 Joanie kernel: [8614238.406351] r8169 0000:09:00.0: System wakeup enabled by ACPI
Aug  5 16:07:46 Joanie kernel: [8614238.406605] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
Aug  5 16:07:46 Joanie kernel: [8614238.406788] ehci-pci 0000:00:1a.0: System wakeup enabled by ACPI
Aug  5 16:07:46 Joanie kernel: [8614238.421198] PM: noirq suspend of devices complete after 15.977 msecs
Aug  5 16:07:46 Joanie kernel: [8614238.421347] ACPI: Preparing to enter system sleep state S3
Aug  5 16:07:46 Joanie kernel: [8614238.605317] ACPI : EC: EC stopped
Aug  5 16:07:46 Joanie kernel: [8614238.605318] PM: Saving platform NVS memory
Aug  5 16:07:46 Joanie kernel: [8614238.605905] Disabling non-boot CPUs ...
Aug  5 16:07:46 Joanie kernel: [8614238.607225] smpboot: CPU 1 is now offline
Aug  5 16:07:46 Joanie kernel: [8614238.617797] Broke affinity for irq 16
Aug  5 16:07:46 Joanie kernel: [8614238.617807] Broke affinity for irq 23
Aug  5 16:07:46 Joanie kernel: [8614238.617811] Broke affinity for irq 26
Aug  5 16:07:46 Joanie kernel: [8614238.618832] smpboot: CPU 2 is now offline
Aug  5 16:07:46 Joanie kernel: [8614238.629676] Broke affinity for irq 1
Aug  5 16:07:46 Joanie kernel: [8614238.629684] Broke affinity for irq 9
Aug  5 16:07:46 Joanie kernel: [8614238.629689] Broke affinity for irq 12
Aug  5 16:07:46 Joanie kernel: [8614238.629694] Broke affinity for irq 16
Aug  5 16:07:46 Joanie kernel: [8614238.629703] Broke affinity for irq 23
Aug  5 16:07:46 Joanie kernel: [8614238.629706] Broke affinity for irq 24
Aug  5 16:07:46 Joanie kernel: [8614238.629707] Broke affinity for irq 25
Aug  5 16:07:46 Joanie kernel: [8614238.629709] Broke affinity for irq 26
Aug  5 16:07:46 Joanie kernel: [8614238.629710] Broke affinity for irq 29
Aug  5 16:07:46 Joanie kernel: [8614238.630726] smpboot: CPU 3 is now offline
Aug  5 16:07:46 Joanie kernel: [8614238.642655] ACPI: Low-level resume complete
Aug  5 16:07:46 Joanie kernel: [8614238.642715] ACPI : EC: EC started
Aug  5 16:07:46 Joanie kernel: [8614238.642716] PM: Restoring platform NVS memory
Aug  5 16:07:46 Joanie kernel: [8614238.643280] Enabling non-boot CPUs ...
Aug  5 16:07:46 Joanie kernel: [8614238.662640] x86: Booting SMP configuration:
Aug  5 16:07:46 Joanie kernel: [8614238.662641] smpboot: Booting Node 0 Processor 1 APIC 0x4
Aug  5 16:07:46 Joanie kernel: [8614238.665238]  cache: parent cpu1 should not be sleeping
Aug  5 16:07:46 Joanie kernel: [8614238.665480] CPU1 is up
Aug  5 16:07:46 Joanie kernel: [8614238.682655] smpboot: Booting Node 0 Processor 2 APIC 0x1
Aug  5 16:07:46 Joanie kernel: [8614238.685156]  cache: parent cpu2 should not be sleeping
Aug  5 16:07:46 Joanie kernel: [8614238.685396] CPU2 is up
Aug  5 16:07:46 Joanie kernel: [8614238.698703] smpboot: Booting Node 0 Processor 3 APIC 0x5
Aug  5 16:07:46 Joanie kernel: [8614238.701219]  cache: parent cpu3 should not be sleeping
Aug  5 16:07:46 Joanie kernel: [8614238.701456] CPU3 is up
Aug  5 16:07:46 Joanie kernel: [8614238.704053] ACPI: Waking up from system sleep state S3
Aug  5 16:07:46 Joanie kernel: [8614238.886683] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
Aug  5 16:07:46 Joanie kernel: [8614238.886826] ehci-pci 0000:00:1a.0: System wakeup disabled by ACPI
Aug  5 16:07:46 Joanie kernel: [8614238.887005] PM: noirq resume of devices complete after 16.470 msecs
Aug  5 16:07:46 Joanie kernel: [8614238.889163] PM: early resume of devices complete after 2.137 msecs
Aug  5 16:07:46 Joanie kernel: [8614238.889400] r8169 0000:09:00.0: System wakeup disabled by ACPI
Aug  5 16:07:46 Joanie kernel: [8614238.890688] sd 0:0:0:0: [sda] Starting disk
Aug  5 16:07:46 Joanie kernel: [8614238.944043] r8169 0000:09:00.0 enp9s0: link down
Aug  5 16:07:46 Joanie kernel: [8614238.999587] rtc_cmos 00:02: System wakeup disabled by ACPI
Aug  5 16:07:46 Joanie kernel: [8614239.118520] usb 1-1.3: reset full-speed USB device number 3 using ehci-pci
Aug  5 16:07:46 Joanie kernel: [8614239.122458] usb 2-1.4: reset high-speed USB device number 3 using ehci-pci
Aug  5 16:07:46 Joanie kernel: [8614239.206504] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug  5 16:07:46 Joanie kernel: [8614239.206768] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
Aug  5 16:07:46 Joanie kernel: [8614239.206770] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
Aug  5 16:07:46 Joanie kernel: [8614239.207322] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
Aug  5 16:07:46 Joanie kernel: [8614239.207324] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
Aug  5 16:07:46 Joanie kernel: [8614239.207516] ata1.00: configured for UDMA/133
Aug  5 16:07:46 Joanie kernel: [8614239.226504] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Aug  5 16:07:46 Joanie kernel: [8614239.227037] ata2.00: unexpected _GTF length (8)
Aug  5 16:07:46 Joanie kernel: [8614239.228559] ata2.00: unexpected _GTF length (8)
Aug  5 16:07:46 Joanie kernel: [8614239.228563] ata2.00: configured for UDMA/100
Aug  5 16:07:46 Joanie kernel: [8614239.230469] ata6: SATA link down (SStatus 0 SControl 300)
Aug  5 16:07:46 Joanie kernel: [8614239.238503] ata5: SATA link down (SStatus 0 SControl 300)
Aug  5 16:07:46 Joanie kernel: [8614239.286481] usb 2-1.2: reset high-speed USB device number 7 using ehci-pci
Aug  5 16:07:46 Joanie kernel: [8614239.286484] usb 1-1.6: reset full-speed USB device number 5 using ehci-pci
Aug  5 16:07:46 Joanie kernel: [8614239.383900] PM: resume of devices complete after 494.766 msecs
Aug  5 16:07:46 Joanie kernel: [8614239.384750] PM: Finishing wakeup.
Aug  5 16:07:46 Joanie systemd[1]: Time has been changed
Aug  5 16:07:46 Joanie console-kit-daemon[5307]: console-kit-daemon[5307]: WARNING: Error waiting for native console 40 activation: Resource temporarily unavailable
Aug  5 16:07:46 Joanie console-kit-daemon[5307]: WARNING: Error waiting for native console 40 activation: Resource temporarily unavailable
Aug  5 16:07:46 Joanie systemd[1806]: Time has been changed
Aug  5 16:07:46 Joanie kernel: [8614239.384753] Restarting tasks ... done.
Aug  5 16:07:46 Joanie bluetoothd[23268]: Failed to obtain handles for "Service Changed" characteristic
Aug  5 16:07:46 Joanie bluetoothd[23268]: Not enough free handles to register service
Aug  5 16:07:46 Joanie bluetoothd[23268]: Error adding Link Loss service
Aug  5 16:07:46 Joanie bluetoothd[23268]: Not enough free handles to register service
Aug  5 16:07:46 Joanie bluetoothd[23268]: message repeated 2 times: [ Not enough free handles to register service]
Aug  5 16:07:46 Joanie bluetoothd[23268]: Current Time Service could not be registered
Aug  5 16:07:46 Joanie bluetoothd[23268]: gatt-time-server: Input/output error (5)
Aug  5 16:07:46 Joanie bluetoothd[23268]: Not enough free handles to register service
Aug  5 16:07:46 Joanie bluetoothd[23268]: Not enough free handles to register service
Aug  5 16:07:46 Joanie bluetoothd[23268]: Sap driver initialization failed.
Aug  5 16:07:46 Joanie bluetoothd[23268]: sap-server: Operation not permitted (1)
Aug  5 16:07:46 Joanie systemd-sleep[15599]: System resumed.
Aug  5 16:07:46 Joanie kernel: [8614239.461301] video LNXVIDEO:01: Restoring backlight state
Aug  5 16:07:46 Joanie systemd-sleep[15599]: Failed to connect to non-global ctrl_ifname: (nil)  error: No such file or directory
Aug  5 16:07:47 Joanie systemd-sleep[15599]: /dev/sda:
Aug  5 16:07:47 Joanie systemd-sleep[15599]:  setting Advanced Power Management level to 0x80 (128)
Aug  5 16:07:47 Joanie systemd-sleep[15599]:  APM_level#011= 128
Aug  5 16:07:47 Joanie systemd[1]: Starting Load/Save RF Kill Switch Status...
Aug  5 16:07:47 Joanie systemd[1]: Started Load/Save RF Kill Switch Status.
Aug  5 16:07:47 Joanie systemd[1]: Reached target Bluetooth.
Aug  5 16:07:47 Joanie systemd-sleep[15599]: /dev/sda:
Aug  5 16:07:47 Joanie systemd-sleep[15599]:  setting standby to 36 (3 minutes)
Aug  5 16:07:47 Joanie systemd-sleep[15752]: /lib/systemd/system-sleep/wpasupplicant failed with error code 255.
Aug  5 16:07:47 Joanie systemd[1]: Started Suspend.
Aug  5 16:07:47 Joanie systemd[1]: sleep.target: Unit not needed anymore. Stopping.
Aug  5 16:07:47 Joanie systemd[1]: Stopped target Sleep.
Aug  5 16:07:47 Joanie systemd[1]: Reached target Suspend.
Aug  5 16:07:47 Joanie systemd[1]: suspend.target: Unit is bound to inactive unit systemd-suspend.service. Stopping, too.
Aug  5 16:07:47 Joanie systemd[1]: Stopped target Suspend.
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.2569] manager: wake requested (sleeping: yes  enabled: yes)
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.2570] manager: waking up...
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.2571] device (enp9s0): state change: unavailable -> unmanaged (reason 'sleeping') [20 10 37]
Aug  5 16:07:47 Joanie systemd[1]: Started Run anacron jobs at resume.
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.2779] device (wlp3s0): state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
Aug  5 16:07:47 Joanie kernel: [8614239.821618] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
Aug  5 16:07:47 Joanie kernel: [8614239.821843] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  5 16:07:47 Joanie kernel: [8614239.829367] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  5 16:07:47 Joanie kernel: [8614239.829474] iwlwifi 0000:03:00.0: Radio type=0x0-0x0-0x3
Aug  5 16:07:47 Joanie kernel: [8614239.866195] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  5 16:07:47 Joanie kernel: [8614239.873750] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  5 16:07:47 Joanie kernel: [8614239.873851] iwlwifi 0000:03:00.0: Radio type=0x0-0x0-0x3
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.3649] device (enp9s0): state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
Aug  5 16:07:47 Joanie kernel: [8614239.906555] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
Aug  5 16:07:47 Joanie kernel: [8614239.908678] IPv6: ADDRCONF(NETDEV_UP): enp9s0: link is not ready
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.4221] manager: NetworkManager state is now DISCONNECTED
Aug  5 16:07:47 Joanie kernel: [8614239.963795] r8169 0000:09:00.0 enp9s0: link down
Aug  5 16:07:47 Joanie kernel: [8614239.963885] IPv6: ADDRCONF(NETDEV_UP): enp9s0: link is not ready
Aug  5 16:07:47 Joanie wpa_supplicant[1135]: dbus: wpa_dbus_get_object_properties: failed to get object properties: (none) none
Aug  5 16:07:47 Joanie wpa_supplicant[1135]: dbus: Failed to construct signal
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.4767] device (wlp3s0): supplicant interface state: starting -> ready
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.4769] device (wlp3s0): state change: unavailable -> disconnected (reason 'supplicant-available') [20 30 42]
Aug  5 16:07:47 Joanie kernel: [8614240.020680] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
Aug  5 16:07:47 Joanie kernel: [8614240.041482] psmouse serio4: synaptics: queried max coordinates: x [..5856], y [..4938]
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.8998] device (wlp3s0): supplicant interface state: ready -> inactive
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.9048] policy: auto-activating connection 'VoicePlex'
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.9061] device (wlp3s0): Activation: starting connection 'VoicePlex' (cf0aa26d-621a-4742-bf42-0b0a1644f3ca)
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.9064] device (wlp3s0): state change: disconnected -> prepare (reason 'none') [30 40 0]
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.9066] manager: NetworkManager state is now CONNECTING
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.9075] device (wlp3s0): state change: prepare -> config (reason 'none') [40 50 0]
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.9079] device (wlp3s0): Activation: (wifi) access point 'VoicePlex' has security, but secrets are required.
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.9080] device (wlp3s0): state change: config -> need-auth (reason 'none') [50 60 0]
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.9138] device (wlp3s0): state change: need-auth -> prepare (reason 'none') [60 40 0]
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.9147] device (wlp3s0): state change: prepare -> config (reason 'none') [40 50 0]
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.9151] device (wlp3s0): Activation: (wifi) connection 'VoicePlex' has security, and secrets exist.  No new secrets needed.
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.9152] Config: added 'ssid' value 'VoicePlex'
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.9153] Config: added 'scan_ssid' value '1'
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.9153] Config: added 'key_mgmt' value 'WPA-PSK'
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.9153] Config: added 'auth_alg' value 'OPEN'
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.9153] Config: added 'psk' value '<omitted>'
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.9172] sup-iface[0xaa30b0,wlp3s0]: config: set interface ap_scan to 1
Aug  5 16:07:47 Joanie wpa_supplicant[1135]: wlp3s0: SME: Trying to authenticate with c0:8a:de:20:2f:68 (SSID='VoicePlex' freq=2412 MHz)
Aug  5 16:07:47 Joanie kernel: [8614240.471635] wlp3s0: authenticate with c0:8a:de:20:2f:68
Aug  5 16:07:47 Joanie kernel: [8614240.473161] wlp3s0: send auth to c0:8a:de:20:2f:68 (try 1/3)
Aug  5 16:07:47 Joanie wpa_supplicant[1135]: wlp3s0: Trying to associate with c0:8a:de:20:2f:68 (SSID='VoicePlex' freq=2412 MHz)
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.9339] device (wlp3s0): supplicant interface state: inactive -> associating
Aug  5 16:07:47 Joanie kernel: [8614240.474664] wlp3s0: authenticated
Aug  5 16:07:47 Joanie kernel: [8614240.478342] wlp3s0: associate with c0:8a:de:20:2f:68 (try 1/3)
Aug  5 16:07:47 Joanie kernel: [8614240.483634] wlp3s0: RX AssocResp from c0:8a:de:20:2f:68 (capab=0x431 status=0 aid=1)
Aug  5 16:07:47 Joanie wpa_supplicant[1135]: wlp3s0: Associated with c0:8a:de:20:2f:68
Aug  5 16:07:47 Joanie kernel: [8614240.487170] wlp3s0: associated
Aug  5 16:07:47 Joanie kernel: [8614240.487273] IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s0: link becomes ready
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.9501] device (wlp3s0): supplicant interface state: associating -> 4-way handshake
Aug  5 16:07:47 Joanie wpa_supplicant[1135]: wlp3s0: WPA: Key negotiation completed with c0:8a:de:20:2f:68 [PTK=CCMP GTK=CCMP]
Aug  5 16:07:47 Joanie wpa_supplicant[1135]: wlp3s0: CTRL-EVENT-CONNECTED - Connection to c0:8a:de:20:2f:68 completed [id=0 id_str=]
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.9575] device (wlp3s0): supplicant interface state: 4-way handshake -> completed
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.9575] device (wlp3s0): Activation: (wifi) Stage 2 of 5 (Device Configure) successful.  Connected to wireless network 'VoicePlex'.
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.9577] device (wlp3s0): state change: config -> ip-config (reason 'none') [50 70 0]
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.9585] dhcp4 (wlp3s0): activation: beginning transaction (timeout in 45 seconds)
Aug  5 16:07:47 Joanie NetworkManager[866]: <info>  [1533499667.9612] dhcp4 (wlp3s0): dhclient started with pid 15810
Aug  5 16:07:48 Joanie dhclient[15810]: DHCPREQUEST of 10.10.10.100 on wlp3s0 to 255.255.255.255 port 67 (xid=0x3a214660)
Aug  5 16:07:48 Joanie dhclient[15810]: DHCPACK of 10.10.10.100 from 10.10.10.254
Aug  5 16:07:48 Joanie NetworkManager[866]: <info>  [1533499668.4152]   address 10.10.10.100
Aug  5 16:07:48 Joanie NetworkManager[866]: <info>  [1533499668.4152]   plen 24 (255.255.255.0)
Aug  5 16:07:48 Joanie NetworkManager[866]: <info>  [1533499668.4153]   gateway 10.10.10.254
Aug  5 16:07:48 Joanie NetworkManager[866]: <info>  [1533499668.4153]   server identifier 10.10.10.254
Aug  5 16:07:48 Joanie NetworkManager[866]: <info>  [1533499668.4153]   lease time 86400
Aug  5 16:07:48 Joanie NetworkManager[866]: <info>  [1533499668.4153]   hostname 'Joanie'
Aug  5 16:07:48 Joanie NetworkManager[866]: <info>  [1533499668.4154]   nameserver '10.10.10.254'
Aug  5 16:07:48 Joanie NetworkManager[866]: <info>  [1533499668.4154] dhcp4 (wlp3s0): state changed unknown -> bound
Aug  5 16:07:48 Joanie NetworkManager[866]: <info>  [1533499668.4200] device (wlp3s0): state change: ip-config -> ip-check (reason 'none') [70 80 0]
Aug  5 16:07:48 Joanie avahi-daemon[15386]: Joining mDNS multicast group on interface wlp3s0.IPv4 with address 10.10.10.100.
Aug  5 16:07:48 Joanie avahi-daemon[15386]: New relevant interface wlp3s0.IPv4 for mDNS.
Aug  5 16:07:48 Joanie avahi-daemon[15386]: Registering new address record for 10.10.10.100 on wlp3s0.IPv4.
Aug  5 16:07:48 Joanie NetworkManager[866]: <info>  [1533499668.4239] device (wlp3s0): state change: ip-check -> secondaries (reason 'none') [80 90 0]
Aug  5 16:07:48 Joanie NetworkManager[866]: <info>  [1533499668.4245] device (wlp3s0): state change: secondaries -> activated (reason 'none') [90 100 0]
Aug  5 16:07:48 Joanie NetworkManager[866]: <info>  [1533499668.4247] manager: NetworkManager state is now CONNECTED_LOCAL
Aug  5 16:07:48 Joanie dhclient[15810]: bound to 10.10.10.100 -- renewal in 36146 seconds.
Aug  5 16:07:48 Joanie NetworkManager[866]: <info>  [1533499668.4332] manager: NetworkManager state is now CONNECTED_GLOBAL
Aug  5 16:07:48 Joanie NetworkManager[866]: <info>  [1533499668.4334] policy: set 'VoicePlex' (wlp3s0) as default for IPv4 routing and DNS
Aug  5 16:07:48 Joanie NetworkManager[866]: <info>  [1533499668.4336] dns-mgr: Writing DNS information to /sbin/resolvconf
Aug  5 16:07:48 Joanie dnsmasq[1324]: setting upstream servers from DBus
Aug  5 16:07:48 Joanie dnsmasq[1324]: using nameserver 10.10.10.254#53
Aug  5 16:07:48 Joanie NetworkManager[866]: <info>  [1533499668.4482] device (wlp3s0): Activation: successful, device activated.
Aug  5 16:07:48 Joanie dbus[850]: [system] Activating via systemd: service name='org.freedesktop.nm_dispatcher' unit='dbus-org.freedesktop.nm-dispatcher.service'
Aug  5 16:07:48 Joanie systemd[1]: Starting Network Manager Script Dispatcher Service...
Aug  5 16:07:48 Joanie dbus[850]: [system] Successfully activated service 'org.freedesktop.nm_dispatcher'
Aug  5 16:07:48 Joanie systemd[1]: Started Network Manager Script Dispatcher Service.
Aug  5 16:07:48 Joanie nm-dispatcher: req:1 'up' [wlp3s0]: new request (1 scripts)
Aug  5 16:07:48 Joanie nm-dispatcher: req:1 'up' [wlp3s0]: start running ordered scripts...
Aug  5 16:07:48 Joanie org.gtk.vfs.Daemon[1873]: ** (process:3196): WARNING **: Couldn't create directory monitor on smb://x-gnome-default-workgroup/. Error: Operation not supported by backend
Aug  5 16:07:48 Joanie org.gtk.vfs.Daemon[1873]: ** (process:3196): WARNING **: Couldn't create directory monitor on smb://x-gnome-default-workgroup/. Error: Operation not supported by backend
Aug  5 16:07:48 Joanie ntpdate[15864]: the NTP socket is in use, exiting
Aug  5 16:07:49 Joanie avahi-daemon[15386]: Joining mDNS multicast group on interface wlp3s0.IPv6 with address fe80::bf52:2694:756c:4265.
Aug  5 16:07:49 Joanie avahi-daemon[15386]: New relevant interface wlp3s0.IPv6 for mDNS.
Aug  5 16:07:49 Joanie avahi-daemon[15386]: Registering new address record for fe80::bf52:2694:756c:4265 on wlp3s0.*.
Aug  5 16:07:51 Joanie ntpd[14595]: Listen normally on 34 wlp3s0 10.10.10.100:123
Aug  5 16:07:51 Joanie ntpd[14595]: Listen normally on 35 wlp3s0 [fe80::bf52:2694:756c:4265%3]:123
Aug  5 16:07:51 Joanie ntpd[14595]: new interface(s) found: waking up resolver
Aug  5 16:09:44 Joanie NetworkManager[866]: <info>  [1533499784.3229] manager: sleep requested (sleeping: no  enabled: yes)
Aug  5 16:09:44 Joanie NetworkManager[866]: <info>  [1533499784.3230] manager: sleeping...
Aug  5 16:09:44 Joanie NetworkManager[866]: <info>  [1533499784.3231] device (wlp3s0): state change: activated -> unmanaged (reason 'sleeping') [100 10 37]
Aug  5 16:09:44 Joanie NetworkManager[866]: <info>  [1533499784.3400] dhcp4 (wlp3s0): canceled DHCP transaction, DHCP client pid 15810
Aug  5 16:09:44 Joanie NetworkManager[866]: <info>  [1533499784.3401] dhcp4 (wlp3s0): state changed bound -> done
Aug  5 16:09:44 Joanie avahi-daemon[15386]: Withdrawing address record for 10.10.10.100 on wlp3s0.
Aug  5 16:09:44 Joanie avahi-daemon[15386]: Leaving mDNS multicast group on interface wlp3s0.IPv4 with address 10.10.10.100.
Aug  5 16:09:44 Joanie kernel: [8614356.876899] wlp3s0: deauthenticating from c0:8a:de:20:2f:68 by local choice (Reason: 3=DEAUTH_LEAVING)
Aug  5 16:09:44 Joanie avahi-daemon[15386]: Interface wlp3s0.IPv4 no longer relevant for mDNS.
Aug  5 16:09:44 Joanie wpa_supplicant[1135]: wlp3s0: CTRL-EVENT-DISCONNECTED bssid=c0:8a:de:20:2f:68 reason=3 locally_generated=1
Aug  5 16:09:44 Joanie avahi-daemon[15386]: Withdrawing address record for fe80::bf52:2694:756c:4265 on wlp3s0.
Aug  5 16:09:44 Joanie NetworkManager[866]: <info>  [1533499784.3538] dns-mgr: Writing DNS information to /sbin/resolvconf
Aug  5 16:09:44 Joanie avahi-daemon[15386]: Leaving mDNS multicast group on interface wlp3s0.IPv6 with address fe80::bf52:2694:756c:4265.
Aug  5 16:09:44 Joanie avahi-daemon[15386]: Interface wlp3s0.IPv6 no longer relevant for mDNS.
Aug  5 16:09:44 Joanie dnsmasq[1324]: setting upstream servers from DBus
Aug  5 16:09:44 Joanie wpa_supplicant[1135]: wlp3s0: CTRL-EVENT-REGDOM-CHANGE init=CORE type=WORLD
Aug  5 16:09:44 Joanie org.gtk.vfs.Daemon[1873]: ** (process:3196): WARNING **: Couldn't create directory monitor on smb://x-gnome-default-workgroup/. Error: Operation not supported by backend
Aug  5 16:09:44 Joanie kernel: [8614356.895286] cfg80211: World regulatory domain updated:
Aug  5 16:09:44 Joanie kernel: [8614356.895292] cfg80211:  DFS Master region: unset
Aug  5 16:09:44 Joanie kernel: [8614356.895295] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
Aug  5 16:09:44 Joanie kernel: [8614356.895299] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
Aug  5 16:09:44 Joanie kernel: [8614356.895303] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
Aug  5 16:09:44 Joanie kernel: [8614356.895307] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
Aug  5 16:09:44 Joanie kernel: [8614356.895311] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (N/A)
Aug  5 16:09:44 Joanie kernel: [8614356.895315] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (0 s)
Aug  5 16:09:44 Joanie kernel: [8614356.895318] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
Aug  5 16:09:44 Joanie kernel: [8614356.895322] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
Aug  5 16:09:44 Joanie kernel: [8614356.895326] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
Aug  5 16:09:44 Joanie NetworkManager[866]: <info>  [1533499784.3692] manager: NetworkManager state is now ASLEEP
Aug  5 16:09:44 Joanie dbus[850]: [system] Activating via systemd: service name='org.freedesktop.nm_dispatcher' unit='dbus-org.freedesktop.nm-dispatcher.service'
Aug  5 16:09:44 Joanie systemd[1]: Reached target Sleep.
Aug  5 16:09:44 Joanie systemd[1]: Starting Suspend...
Aug  5 16:09:44 Joanie wpa_supplicant[1135]: nl80211: deinit ifname=wlp3s0 disabled_11b_rates=0
Aug  5 16:09:44 Joanie systemd[1]: Starting Network Manager Script Dispatcher Service...
Aug  5 16:09:44 Joanie dbus[850]: [system] Successfully activated service 'org.freedesktop.nm_dispatcher'
Aug  5 16:09:44 Joanie systemd[1]: Started Network Manager Script Dispatcher Service.
Aug  5 16:09:44 Joanie nm-dispatcher: req:1 'down' [wlp3s0]: new request (1 scripts)
Aug  5 16:09:44 Joanie nm-dispatcher: req:1 'down' [wlp3s0]: start running ordered scripts...
Aug  5 16:09:46 Joanie ntpd[14595]: Deleting interface #34 wlp3s0, 10.10.10.100#123, interface stats: received=97, sent=97, dropped=0, active_time=115 secs
Aug  5 16:09:46 Joanie ntpd[14595]: 98.191.213.14 local addr 10.10.10.100 -> <null>
Aug  5 16:09:46 Joanie ntpd[14595]: 129.6.15.30 local addr 10.10.10.100 -> <null>
Aug  5 16:09:46 Joanie ntpd[14595]: 129.6.15.28 local addr 10.10.10.100 -> <null>
Aug  5 16:09:46 Joanie ntpd[14595]: 216.93.242.12 local addr 10.10.10.100 -> <null>
Aug  5 16:09:46 Joanie ntpd[14595]: 12.167.151.1 local addr 10.10.10.100 -> <null>
Aug  5 16:09:46 Joanie ntpd[14595]: 128.10.19.24 local addr 10.10.10.100 -> <null>
Aug  5 16:09:46 Joanie ntpd[14595]: 162.221.74.15 local addr 10.10.10.100 -> <null>
Aug  5 16:09:46 Joanie ntpd[14595]: 45.56.105.98 local addr 10.10.10.100 -> <null>
Aug  5 16:09:46 Joanie ntpd[14595]: 108.61.73.244 local addr 10.10.10.100 -> <null>
Aug  5 16:09:46 Joanie ntpd[14595]: 216.229.0.50 local addr 10.10.10.100 -> <null>
Aug  5 16:09:46 Joanie ntpd[14595]: 45.63.11.93 local addr 10.10.10.100 -> <null>
Aug  5 16:09:46 Joanie ntpd[14595]: 140.82.7.153 local addr 10.10.10.100 -> <null>
Aug  5 16:09:46 Joanie ntpd[14595]: 69.164.201.245 local addr 10.10.10.100 -> <null>
Aug  5 16:09:46 Joanie ntpd[14595]: 66.207.226.14 local addr 10.10.10.100 -> <null>
Aug  5 16:09:46 Joanie ntpd[14595]: Deleting interface #35 wlp3s0, fe80::bf52:2694:756c:4265%3#123, interface stats: received=0, sent=0, dropped=0, active_time=115 secs
Aug  5 16:09:54 Joanie systemd-sleep[16076]: Selected interface 'wlp3s0'
Aug  5 16:09:54 Joanie systemd-sleep[16076]: 'SUSPEND' command timed out.
Aug  5 16:09:54 Joanie systemd-sleep[16080]: /lib/systemd/system-sleep/wpasupplicant failed with error code 254.
Aug  5 16:09:54 Joanie systemd-sleep[16076]: Suspending system...
Aug  5 19:22:06 Joanie kernel: [8614366.955310] PM: Syncing filesystems ... done.
Aug  5 19:22:06 Joanie kernel: [8614366.970048] PM: Preparing system for sleep (mem)
Aug  5 19:22:06 Joanie kernel: [8614366.970410] Freezing user space processes ... (elapsed 0.002 seconds) done.
Aug  5 19:22:06 Joanie kernel: [8614366.972588] Freezing remaining freezable tasks ... (elapsed 0.048 seconds) done.
Aug  5 19:22:06 Joanie kernel: [8614367.021487] PM: Suspending system (mem)
Aug  5 19:22:06 Joanie kernel: [8614367.021569] Suspending console(s) (use no_console_suspend to debug)
Aug  5 19:22:06 Joanie kernel: [8614367.176377] sd 0:0:0:0: [sda] Synchronizing SCSI cache
Aug  5 19:22:06 Joanie kernel: [8614367.177209] sd 0:0:0:0: [sda] Stopping disk
Aug  5 19:22:06 Joanie kernel: [8614367.464398] PM: suspend of devices complete after 442.634 msecs
Aug  5 19:22:06 Joanie kernel: [8614367.478139] PM: late suspend of devices complete after 13.737 msecs
Aug  5 19:22:06 Joanie kernel: [8614367.479236] r8169 0000:09:00.0: System wakeup enabled by ACPI
Aug  5 19:22:06 Joanie kernel: [8614367.479524] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
Aug  5 19:22:06 Joanie kernel: [8614367.479775] ehci-pci 0000:00:1a.0: System wakeup enabled by ACPI
Aug  5 19:22:06 Joanie kernel: [8614367.494181] PM: noirq suspend of devices complete after 16.038 msecs
Aug  5 19:22:06 Joanie kernel: [8614367.494354] ACPI: Preparing to enter system sleep state S3
Aug  5 19:22:06 Joanie kernel: [8614367.678300] ACPI : EC: EC stopped
Aug  5 19:22:06 Joanie kernel: [8614367.678301] PM: Saving platform NVS memory
Aug  5 19:22:06 Joanie kernel: [8614367.679270] Disabling non-boot CPUs ...
Aug  5 19:22:06 Joanie kernel: [8614367.680732] smpboot: CPU 1 is now offline
Aug  5 19:22:06 Joanie kernel: [8614367.691038] Broke affinity for irq 16
Aug  5 19:22:06 Joanie kernel: [8614367.691050] Broke affinity for irq 23
Aug  5 19:22:06 Joanie kernel: [8614367.691056] Broke affinity for irq 26
Aug  5 19:22:06 Joanie kernel: [8614367.692103] smpboot: CPU 2 is now offline
Aug  5 19:22:06 Joanie kernel: [8614367.702981] Broke affinity for irq 1
Aug  5 19:22:06 Joanie kernel: [8614367.702991] Broke affinity for irq 9
Aug  5 19:22:06 Joanie kernel: [8614367.702997] Broke affinity for irq 12
Aug  5 19:22:06 Joanie kernel: [8614367.703003] Broke affinity for irq 16
Aug  5 19:22:06 Joanie kernel: [8614367.703014] Broke affinity for irq 23
Aug  5 19:22:06 Joanie kernel: [8614367.703018] Broke affinity for irq 24
Aug  5 19:22:06 Joanie kernel: [8614367.703020] Broke affinity for irq 25
Aug  5 19:22:06 Joanie kernel: [8614367.703022] Broke affinity for irq 26
Aug  5 19:22:06 Joanie kernel: [8614367.703024] Broke affinity for irq 29
Aug  5 19:22:06 Joanie kernel: [8614367.704056] smpboot: CPU 3 is now offline
Aug  5 19:22:06 Joanie kernel: [8614367.715519] ACPI: Low-level resume complete
Aug  5 19:22:06 Joanie kernel: [8614367.715579] ACPI : EC: EC started
Aug  5 19:22:06 Joanie kernel: [8614367.715580] PM: Restoring platform NVS memory
Aug  5 19:22:06 Joanie kernel: [8614367.716147] Enabling non-boot CPUs ...
Aug  5 19:22:06 Joanie kernel: [8614367.735551] x86: Booting SMP configuration:
Aug  5 19:22:06 Joanie kernel: [8614367.735552] smpboot: Booting Node 0 Processor 1 APIC 0x4
Aug  5 19:22:06 Joanie kernel: [8614367.738162]  cache: parent cpu1 should not be sleeping
Aug  5 19:22:06 Joanie kernel: [8614367.738404] CPU1 is up
Aug  5 19:22:06 Joanie kernel: [8614367.755570] smpboot: Booting Node 0 Processor 2 APIC 0x1
Aug  5 19:22:06 Joanie kernel: [8614367.758065]  cache: parent cpu2 should not be sleeping
Aug  5 19:22:06 Joanie kernel: [8614367.758308] CPU2 is up
Aug  5 19:22:06 Joanie kernel: [8614367.771618] smpboot: Booting Node 0 Processor 3 APIC 0x5
Aug  5 19:22:06 Joanie kernel: [8614367.774134]  cache: parent cpu3 should not be sleeping
Aug  5 19:22:06 Joanie kernel: [8614367.774375] CPU3 is up
Aug  5 19:22:06 Joanie kernel: [8614367.776970] ACPI: Waking up from system sleep state S3
Aug  5 19:22:06 Joanie kernel: [8614367.959562] ehci-pci 0000:00:1a.0: System wakeup disabled by ACPI
Aug  5 19:22:06 Joanie kernel: [8614367.959596] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
Aug  5 19:22:06 Joanie kernel: [8614367.959940] PM: noirq resume of devices complete after 16.488 msecs
Aug  5 19:22:06 Joanie kernel: [8614367.962042] PM: early resume of devices complete after 2.080 msecs
Aug  5 19:22:06 Joanie kernel: [8614367.962325] r8169 0000:09:00.0: System wakeup disabled by ACPI
Aug  5 19:22:06 Joanie kernel: [8614367.962663] sd 0:0:0:0: [sda] Starting disk
Aug  5 19:22:06 Joanie kernel: [8614368.016888] r8169 0000:09:00.0 enp9s0: link down
Aug  5 19:22:06 Joanie kernel: [8614368.072365] rtc_cmos 00:02: System wakeup disabled by ACPI
Aug  5 19:22:06 Joanie kernel: [8614368.191380] usb 2-1.4: reset high-speed USB device number 3 using ehci-pci
Aug  5 19:22:06 Joanie kernel: [8614368.191397] usb 1-1.3: reset full-speed USB device number 3 using ehci-pci
Aug  5 19:22:06 Joanie kernel: [8614368.291353] ata5: SATA link down (SStatus 0 SControl 300)
Aug  5 19:22:06 Joanie kernel: [8614368.295371] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Aug  5 19:22:06 Joanie kernel: [8614368.295974] ata2.00: unexpected _GTF length (8)
Aug  5 19:22:06 Joanie kernel: [8614368.297449] ata2.00: unexpected _GTF length (8)
Aug  5 19:22:06 Joanie kernel: [8614368.297454] ata2.00: configured for UDMA/100
Aug  5 19:22:06 Joanie kernel: [8614368.303420] ata6: SATA link down (SStatus 0 SControl 300)
Aug  5 19:22:06 Joanie kernel: [8614368.355377] usb 1-1.6: reset full-speed USB device number 5 using ehci-pci
Aug  5 19:22:06 Joanie kernel: [8614368.359414] usb 2-1.2: reset high-speed USB device number 7 using ehci-pci
Aug  5 19:22:06 Joanie kernel: [8614368.456750] PM: resume of devices complete after 494.733 msecs
Aug  5 19:22:06 Joanie kernel: [8614368.457330] PM: Finishing wakeup.
Aug  5 19:22:06 Joanie systemd[1]: Time has been changed
Aug  5 19:22:06 Joanie systemd[1806]: Time has been changed
Aug  5 19:22:06 Joanie kernel: [8614368.457331] Restarting tasks ... done.
Aug  5 19:22:06 Joanie systemd[1]: Starting Load/Save RF Kill Switch Status...
Aug  5 19:22:06 Joanie systemd[1]: bluetooth.target: Unit not needed anymore. Stopping.
Aug  5 19:22:06 Joanie systemd[1]: Stopped target Bluetooth.
Aug  5 19:22:06 Joanie bluetoothd[23268]: Failed to obtain handles for "Service Changed" characteristic
Aug  5 19:22:06 Joanie bluetoothd[23268]: Not enough free handles to register service
Aug  5 19:22:06 Joanie bluetoothd[23268]: Error adding Link Loss service
Aug  5 19:22:06 Joanie bluetoothd[23268]: Not enough free handles to register service
Aug  5 19:22:06 Joanie systemd[1]: Reached target Bluetooth.
Aug  5 19:22:06 Joanie bluetoothd[23268]: Not enough free handles to register service
Aug  5 19:22:06 Joanie bluetoothd[23268]: Not enough free handles to register service
Aug  5 19:22:06 Joanie bluetoothd[23268]: Current Time Service could not be registered
Aug  5 19:22:06 Joanie bluetoothd[23268]: gatt-time-server: Input/output error (5)
Aug  5 19:22:06 Joanie bluetoothd[23268]: Not enough free handles to register service
Aug  5 19:22:06 Joanie bluetoothd[23268]: Not enough free handles to register service
Aug  5 19:22:06 Joanie bluetoothd[23268]: Sap driver initialization failed.
Aug  5 19:22:06 Joanie systemd[1]: Started Load/Save RF Kill Switch Status.
Aug  5 19:22:06 Joanie bluetoothd[23268]: sap-server: Operation not permitted (1)
Aug  5 19:22:06 Joanie kernel: [8614368.530753] video LNXVIDEO:01: Restoring backlight state
Aug  5 19:22:06 Joanie systemd-sleep[16076]: System resumed.
Aug  5 19:22:06 Joanie systemd-sleep[16076]: Failed to connect to non-global ctrl_ifname: (nil)  error: No such file or directory
Aug  5 19:22:07 Joanie kernel: [8614369.101255] psmouse serio4: synaptics: queried max coordinates: x [..5856], y [..4938]
Aug  5 19:22:07 Joanie kernel: [8614369.191361] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug  5 19:22:07 Joanie kernel: [8614369.192433] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
Aug  5 19:22:07 Joanie kernel: [8614369.192439] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
Aug  5 19:22:07 Joanie kernel: [8614369.194960] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
Aug  5 19:22:07 Joanie kernel: [8614369.194964] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
Aug  5 19:22:07 Joanie kernel: [8614369.195140] ata1.00: configured for UDMA/133
Aug  5 19:22:07 Joanie systemd-sleep[16076]: /dev/sda:
Aug  5 19:22:07 Joanie systemd-sleep[16076]:  setting Advanced Power Management level to 0x80 (128)
Aug  5 19:22:07 Joanie systemd-sleep[16076]:  APM_level#011= 128
Aug  5 19:22:07 Joanie systemd-sleep[16076]: /dev/sda:
Aug  5 19:22:07 Joanie systemd-sleep[16076]:  setting standby to 36 (3 minutes)
Aug  5 19:22:07 Joanie systemd-sleep[16123]: /lib/systemd/system-sleep/wpasupplicant failed with error code 255.
Aug  5 19:22:07 Joanie systemd[1]: Started Suspend.
Aug  5 19:22:07 Joanie systemd[1]: sleep.target: Unit not needed anymore. Stopping.
Aug  5 19:22:07 Joanie systemd[1]: Stopped target Sleep.
Aug  5 19:22:07 Joanie systemd[1]: Reached target Suspend.
Aug  5 19:22:07 Joanie systemd[1]: suspend.target: Unit is bound to inactive unit systemd-suspend.service. Stopping, too.
Aug  5 19:22:07 Joanie systemd[1]: Stopped target Suspend.
Aug  5 19:22:07 Joanie kernel: [8614369.554881] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
Aug  5 19:22:07 Joanie kernel: [8614369.555090] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  5 19:22:07 Joanie kernel: [8614369.562684] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  5 19:22:07 Joanie kernel: [8614369.562787] iwlwifi 0000:03:00.0: Radio type=0x0-0x0-0x3
Aug  5 19:22:07 Joanie NetworkManager[866]: <info>  [1533511327.9194] manager: wake requested (sleeping: yes  enabled: yes)
Aug  5 19:22:07 Joanie NetworkManager[866]: <info>  [1533511327.9195] manager: waking up...
Aug  5 19:22:07 Joanie NetworkManager[866]: <info>  [1533511327.9196] device (enp9s0): state change: unavailable -> unmanaged (reason 'sleeping') [20 10 37]
Aug  5 19:22:07 Joanie NetworkManager[866]: <info>  [1533511327.9382] device (wlp3s0): state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
Aug  5 19:22:07 Joanie systemd[1]: Started Run anacron jobs at resume.
Aug  5 19:22:07 Joanie kernel: [8614369.596983] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  5 19:22:07 Joanie kernel: [8614369.604480] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  5 19:22:07 Joanie kernel: [8614369.604580] iwlwifi 0000:03:00.0: Radio type=0x0-0x0-0x3
Aug  5 19:22:08 Joanie kernel: [8614369.637751] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.0230] device (enp9s0): state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
Aug  5 19:22:08 Joanie kernel: [8614369.639790] IPv6: ADDRCONF(NETDEV_UP): enp9s0: link is not ready
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.0824] manager: NetworkManager state is now DISCONNECTED
Aug  5 19:22:08 Joanie kernel: [8614369.696618] r8169 0000:09:00.0 enp9s0: link down
Aug  5 19:22:08 Joanie kernel: [8614369.696704] IPv6: ADDRCONF(NETDEV_UP): enp9s0: link is not ready
Aug  5 19:22:08 Joanie wpa_supplicant[1135]: dbus: wpa_dbus_get_object_properties: failed to get object properties: (none) none
Aug  5 19:22:08 Joanie wpa_supplicant[1135]: dbus: Failed to construct signal
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.1405] device (wlp3s0): supplicant interface state: starting -> ready
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.1407] device (wlp3s0): state change: unavailable -> disconnected (reason 'supplicant-available') [20 30 42]
Aug  5 19:22:08 Joanie kernel: [8614369.757164] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.5676] device (wlp3s0): supplicant interface state: ready -> inactive
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.5726] policy: auto-activating connection 'VoicePlex'
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.5743] device (wlp3s0): Activation: starting connection 'VoicePlex' (cf0aa26d-621a-4742-bf42-0b0a1644f3ca)
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.5745] device (wlp3s0): state change: disconnected -> prepare (reason 'none') [30 40 0]
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.5746] manager: NetworkManager state is now CONNECTING
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.5752] device (wlp3s0): state change: prepare -> config (reason 'none') [40 50 0]
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.5755] device (wlp3s0): Activation: (wifi) access point 'VoicePlex' has security, but secrets are required.
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.5755] device (wlp3s0): state change: config -> need-auth (reason 'none') [50 60 0]
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.5802] device (wlp3s0): state change: need-auth -> prepare (reason 'none') [60 40 0]
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.5806] device (wlp3s0): state change: prepare -> config (reason 'none') [40 50 0]
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.5809] device (wlp3s0): Activation: (wifi) connection 'VoicePlex' has security, and secrets exist.  No new secrets needed.
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.5810] Config: added 'ssid' value 'VoicePlex'
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.5811] Config: added 'scan_ssid' value '1'
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.5811] Config: added 'key_mgmt' value 'WPA-PSK'
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.5811] Config: added 'auth_alg' value 'OPEN'
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.5811] Config: added 'psk' value '<omitted>'
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.5836] sup-iface[0xb0f7a0,wlp3s0]: config: set interface ap_scan to 1
Aug  5 19:22:08 Joanie wpa_supplicant[1135]: wlp3s0: SME: Trying to authenticate with c0:8a:de:20:2f:68 (SSID='VoicePlex' freq=2412 MHz)
Aug  5 19:22:08 Joanie wpa_supplicant[1135]: wlp3s0: Trying to associate with c0:8a:de:20:2f:68 (SSID='VoicePlex' freq=2412 MHz)
Aug  5 19:22:08 Joanie kernel: [8614370.211535] wlp3s0: authenticate with c0:8a:de:20:2f:68
Aug  5 19:22:08 Joanie kernel: [8614370.213147] wlp3s0: send auth to c0:8a:de:20:2f:68 (try 1/3)
Aug  5 19:22:08 Joanie kernel: [8614370.214708] wlp3s0: authenticated
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.6009] device (wlp3s0): supplicant interface state: inactive -> associating
Aug  5 19:22:08 Joanie kernel: [8614370.215395] wlp3s0: associate with c0:8a:de:20:2f:68 (try 1/3)
Aug  5 19:22:08 Joanie kernel: [8614370.219353] wlp3s0: RX AssocResp from c0:8a:de:20:2f:68 (capab=0x431 status=0 aid=5)
Aug  5 19:22:08 Joanie kernel: [8614370.222822] wlp3s0: associated
Aug  5 19:22:08 Joanie kernel: [8614370.222893] IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s0: link becomes ready
Aug  5 19:22:08 Joanie wpa_supplicant[1135]: wlp3s0: Associated with c0:8a:de:20:2f:68
Aug  5 19:22:08 Joanie wpa_supplicant[1135]: wlp3s0: WPA: Key negotiation completed with c0:8a:de:20:2f:68 [PTK=CCMP GTK=CCMP]
Aug  5 19:22:08 Joanie wpa_supplicant[1135]: wlp3s0: CTRL-EVENT-CONNECTED - Connection to c0:8a:de:20:2f:68 completed [id=0 id_str=]
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.6153] device (wlp3s0): supplicant interface state: associating -> completed
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.6157] device (wlp3s0): Activation: (wifi) Stage 2 of 5 (Device Configure) successful.  Connected to wireless network 'VoicePlex'.
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.6161] device (wlp3s0): state change: config -> ip-config (reason 'none') [50 70 0]
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.6166] dhcp4 (wlp3s0): activation: beginning transaction (timeout in 45 seconds)
Aug  5 19:22:08 Joanie NetworkManager[866]: <info>  [1533511328.6202] dhcp4 (wlp3s0): dhclient started with pid 16178
Aug  5 19:22:08 Joanie dhclient[16178]: DHCPREQUEST of 10.10.10.100 on wlp3s0 to 255.255.255.255 port 67 (xid=0x468688e1)
Aug  5 19:22:08 Joanie dhclient[16178]: DHCPACK of 10.10.10.100 from 10.10.10.254
Aug  5 19:22:09 Joanie NetworkManager[866]: <info>  [1533511329.0639]   address 10.10.10.100
Aug  5 19:22:09 Joanie NetworkManager[866]: <info>  [1533511329.0640]   plen 24 (255.255.255.0)
Aug  5 19:22:09 Joanie NetworkManager[866]: <info>  [1533511329.0640]   gateway 10.10.10.254
Aug  5 19:22:09 Joanie NetworkManager[866]: <info>  [1533511329.0640]   server identifier 10.10.10.254
Aug  5 19:22:09 Joanie NetworkManager[866]: <info>  [1533511329.0641]   lease time 86400
Aug  5 19:22:09 Joanie NetworkManager[866]: <info>  [1533511329.0641]   hostname 'Joanie'
Aug  5 19:22:09 Joanie NetworkManager[866]: <info>  [1533511329.0642]   nameserver '10.10.10.254'
Aug  5 19:22:09 Joanie NetworkManager[866]: <info>  [1533511329.0642] dhcp4 (wlp3s0): state changed unknown -> bound
Aug  5 19:22:09 Joanie avahi-daemon[15386]: Joining mDNS multicast group on interface wlp3s0.IPv4 with address 10.10.10.100.
Aug  5 19:22:09 Joanie avahi-daemon[15386]: New relevant interface wlp3s0.IPv4 for mDNS.
Aug  5 19:22:09 Joanie avahi-daemon[15386]: Registering new address record for 10.10.10.100 on wlp3s0.IPv4.
Aug  5 19:22:09 Joanie NetworkManager[866]: <info>  [1533511329.0704] device (wlp3s0): state change: ip-config -> ip-check (reason 'none') [70 80 0]
Aug  5 19:22:09 Joanie NetworkManager[866]: <info>  [1533511329.0720] device (wlp3s0): state change: ip-check -> secondaries (reason 'none') [80 90 0]
Aug  5 19:22:09 Joanie NetworkManager[866]: <info>  [1533511329.0731] device (wlp3s0): state change: secondaries -> activated (reason 'none') [90 100 0]
Aug  5 19:22:09 Joanie NetworkManager[866]: <info>  [1533511329.0735] manager: NetworkManager state is now CONNECTED_LOCAL
Aug  5 19:22:09 Joanie dhclient[16178]: bound to 10.10.10.100 -- renewal in 43155 seconds.
Aug  5 19:22:09 Joanie NetworkManager[866]: <info>  [1533511329.0874] manager: NetworkManager state is now CONNECTED_GLOBAL
Aug  5 19:22:09 Joanie NetworkManager[866]: <info>  [1533511329.0875] policy: set 'VoicePlex' (wlp3s0) as default for IPv4 routing and DNS
Aug  5 19:22:09 Joanie NetworkManager[866]: <info>  [1533511329.0878] dns-mgr: Writing DNS information to /sbin/resolvconf
Aug  5 19:22:09 Joanie dnsmasq[1324]: setting upstream servers from DBus
Aug  5 19:22:09 Joanie dnsmasq[1324]: using nameserver 10.10.10.254#53
Aug  5 19:22:09 Joanie NetworkManager[866]: <info>  [1533511329.0983] device (wlp3s0): Activation: successful, device activated.
Aug  5 19:22:09 Joanie dbus[850]: [system] Activating via systemd: service name='org.freedesktop.nm_dispatcher' unit='dbus-org.freedesktop.nm-dispatcher.service'
Aug  5 19:22:09 Joanie systemd[1]: Starting Network Manager Script Dispatcher Service...
Aug  5 19:22:09 Joanie dbus[850]: [system] Successfully activated service 'org.freedesktop.nm_dispatcher'
Aug  5 19:22:09 Joanie systemd[1]: Started Network Manager Script Dispatcher Service.
Aug  5 19:22:09 Joanie nm-dispatcher: req:1 'up' [wlp3s0]: new request (1 scripts)
Aug  5 19:22:09 Joanie nm-dispatcher: req:1 'up' [wlp3s0]: start running ordered scripts...
Aug  5 19:22:09 Joanie org.gtk.vfs.Daemon[1873]: ** (process:3196): WARNING **: Couldn't create directory monitor on smb://x-gnome-default-workgroup/. Error: Operation not supported by backend
Aug  5 19:22:09 Joanie org.gtk.vfs.Daemon[1873]: ** (process:3196): WARNING **: Couldn't create directory monitor on smb://x-gnome-default-workgroup/. Error: Operation not supported by backend
Aug  5 19:22:09 Joanie ntpdate[16235]: the NTP socket is in use, exiting
Aug  5 19:22:10 Joanie ntpd[14595]: Listen normally on 36 wlp3s0 10.10.10.100:123
Aug  5 19:22:10 Joanie ntpd[14595]: bind(21) AF_INET6 fe80::bf52:2694:756c:4265%3#123 flags 0x11 failed: Cannot assign requested address
Aug  5 19:22:10 Joanie ntpd[14595]: unable to create socket on wlp3s0 (37) for fe80::bf52:2694:756c:4265%3#123
Aug  5 19:22:10 Joanie ntpd[14595]: failed to init interface for address fe80::bf52:2694:756c:4265%3
Aug  5 19:22:10 Joanie ntpd[14595]: new interface(s) found: waking up resolver
Aug  5 19:22:10 Joanie avahi-daemon[15386]: Joining mDNS multicast group on interface wlp3s0.IPv6 with address fe80::bf52:2694:756c:4265.
Aug  5 19:22:10 Joanie avahi-daemon[15386]: New relevant interface wlp3s0.IPv6 for mDNS.
Aug  5 19:22:10 Joanie avahi-daemon[15386]: Registering new address record for fe80::bf52:2694:756c:4265 on wlp3s0.*.
Aug  5 19:22:12 Joanie ntpd[14595]: Listen normally on 38 wlp3s0 [fe80::bf52:2694:756c:4265%3]:123
Aug  5 19:22:12 Joanie ntpd[14595]: new interface(s) found: waking up resolver
Aug  5 19:22:14 Joanie kernel: [8614375.842829] usb 1-1.1: new high-speed USB device number 14 using ehci-pci
Aug  5 19:22:14 Joanie kernel: [8614375.941560] usb 1-1.1: New USB device found, idVendor=090c, idProduct=1000
Aug  5 19:22:14 Joanie kernel: [8614375.941570] usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Aug  5 19:22:14 Joanie kernel: [8614375.941575] usb 1-1.1: Product: Flash Drive
Aug  5 19:22:14 Joanie kernel: [8614375.941580] usb 1-1.1: Manufacturer: Samsung
Aug  5 19:22:14 Joanie kernel: [8614375.941585] usb 1-1.1: SerialNumber: 0375717070007140
Aug  5 19:22:14 Joanie kernel: [8614375.942994] usb-storage 1-1.1:1.0: USB Mass Storage device detected
Aug  5 19:22:14 Joanie kernel: [8614375.944733] scsi host15: usb-storage 1-1.1:1.0
Aug  5 19:22:14 Joanie mtp-probe: checking bus 1, device 14: "/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.1"
Aug  5 19:22:14 Joanie mtp-probe: bus: 1, device: 14 was not an MTP device
Aug  5 19:22:15 Joanie kernel: [8614377.164209] scsi 15:0:0:0: Direct-Access     Samsung  Flash Drive      1100 PQ: 0 ANSI: 6
Aug  5 19:22:15 Joanie kernel: [8614377.165297] sd 15:0:0:0: Attached scsi generic sg2 type 0
Aug  5 19:22:15 Joanie kernel: [8614377.166127] sd 15:0:0:0: [sdb] 62668800 512-byte logical blocks: (32.1 GB/29.9 GiB)
Aug  5 19:22:15 Joanie kernel: [8614377.167078] sd 15:0:0:0: [sdb] Write Protect is off
Aug  5 19:22:15 Joanie kernel: [8614377.167083] sd 15:0:0:0: [sdb] Mode Sense: 43 00 00 00
Aug  5 19:22:15 Joanie kernel: [8614377.168212] sd 15:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Aug  5 19:22:15 Joanie kernel: [8614377.178012]  sdb: sdb1
Aug  5 19:22:15 Joanie kernel: [8614377.182497] sd 15:0:0:0: [sdb] Attached SCSI removable disk
Aug  5 19:22:30 Joanie ntpd[14595]: Soliciting pool server 103.105.51.156
Aug  5 19:22:31 Joanie ntpd[14595]: Soliciting pool server 198.55.111.50
Aug  5 19:22:35 Joanie udisksd[2007]: Mounted /dev/sdb1 at /media/dkosek/Samsung USB on behalf of uid 1000
Aug  5 19:23:55 Joanie udisksd[2007]: Cleaning up mount point /media/dkosek/Samsung USB (device 8:17 is not mounted)
Aug  5 19:23:55 Joanie udisksd[2007]: Unmounted /dev/sdb1 on behalf of uid 1000
Aug  5 19:23:59 Joanie kernel: [8614480.853352] usb 1-1.1: USB disconnect, device number 14
Aug  5 19:30:54 Joanie dbus[850]: [system] Activating via systemd: service name='org.freedesktop.PackageKit' unit='packagekit.service'
Aug  5 19:30:54 Joanie systemd[1]: Starting PackageKit Daemon...
Aug  5 19:30:54 Joanie PackageKit: daemon start
Aug  5 19:30:54 Joanie dbus[850]: [system] Successfully activated service 'org.freedesktop.PackageKit'
Aug  5 19:30:54 Joanie systemd[1]: Started PackageKit Daemon.
Aug  5 19:34:47 Joanie kernel: [8615129.462201] usb 1-1.1: new high-speed USB device number 15 using ehci-pci
Aug  5 19:34:47 Joanie kernel: [8615129.560856] usb 1-1.1: New USB device found, idVendor=090c, idProduct=1000
Aug  5 19:34:47 Joanie kernel: [8615129.560865] usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Aug  5 19:34:47 Joanie kernel: [8615129.560871] usb 1-1.1: Product: Flash Drive
Aug  5 19:34:47 Joanie kernel: [8615129.560875] usb 1-1.1: Manufacturer: Samsung
Aug  5 19:34:47 Joanie kernel: [8615129.560880] usb 1-1.1: SerialNumber: 0375717070007140
Aug  5 19:34:47 Joanie kernel: [8615129.562296] usb-storage 1-1.1:1.0: USB Mass Storage device detected
Aug  5 19:34:47 Joanie kernel: [8615129.563909] scsi host16: usb-storage 1-1.1:1.0
Aug  5 19:34:48 Joanie mtp-probe: checking bus 1, device 15: "/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.1"
Aug  5 19:34:48 Joanie mtp-probe: bus: 1, device: 15 was not an MTP device
Aug  5 19:34:49 Joanie kernel: [8615130.782316] scsi 16:0:0:0: Direct-Access     Samsung  Flash Drive      1100 PQ: 0 ANSI: 6
Aug  5 19:34:49 Joanie kernel: [8615130.783245] sd 16:0:0:0: Attached scsi generic sg2 type 0
Aug  5 19:34:49 Joanie kernel: [8615130.784134] sd 16:0:0:0: [sdb] 62668800 512-byte logical blocks: (32.1 GB/29.9 GiB)
Aug  5 19:34:49 Joanie kernel: [8615130.785158] sd 16:0:0:0: [sdb] Write Protect is off
Aug  5 19:34:49 Joanie kernel: [8615130.785171] sd 16:0:0:0: [sdb] Mode Sense: 43 00 00 00
Aug  5 19:34:49 Joanie kernel: [8615130.786306] sd 16:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Aug  5 19:34:49 Joanie kernel: [8615130.793715]  sdb: sdb1
Aug  5 19:34:49 Joanie kernel: [8615130.798440] sd 16:0:0:0: [sdb] Attached SCSI removable disk
Aug  5 19:35:31 Joanie udisksd[2007]: Mounted /dev/sdb1 at /media/dkosek/Samsung USB on behalf of uid 1000
Aug  5 19:35:32 Joanie kernel: [8615173.886875] nemo[1907]: segfault at a ip 00007f49ddd099de sp 00007ffdf20412a8 error 4 in libc-2.23.so (deleted)[7f49ddc6b000+1bf000]
Aug  5 19:35:59 Joanie PackageKit: daemon quit
Aug  5 19:35:59 Joanie packagekitd[17043]: (packagekitd:17043): GLib-CRITICAL **: Source ID 9 was not found when attempting to remove it
Aug  5 19:36:29 Joanie udisksd[2007]: Cleaning up mount point /media/dkosek/Samsung USB (device 8:17 is not mounted)
Aug  5 19:36:29 Joanie udisksd[2007]: Unmounted /dev/sdb1 on behalf of uid 1000
Aug  5 19:36:42 Joanie kernel: [8615244.199824] usb 1-1.1: USB disconnect, device number 15
Aug  5 19:37:57 Joanie NetworkManager[866]: <info>  [1533512277.5216] manager: sleep requested (sleeping: no  enabled: yes)
Aug  5 19:37:57 Joanie NetworkManager[866]: <info>  [1533512277.5216] manager: sleeping...
Aug  5 19:37:57 Joanie NetworkManager[866]: <info>  [1533512277.5217] device (wlp3s0): state change: activated -> unmanaged (reason 'sleeping') [100 10 37]
Aug  5 19:37:57 Joanie NetworkManager[866]: <info>  [1533512277.5549] dhcp4 (wlp3s0): canceled DHCP transaction, DHCP client pid 16178
Aug  5 19:37:57 Joanie NetworkManager[866]: <info>  [1533512277.5550] dhcp4 (wlp3s0): state changed bound -> done
Aug  5 19:37:57 Joanie avahi-daemon[15386]: Withdrawing address record for 10.10.10.100 on wlp3s0.
Aug  5 19:37:57 Joanie avahi-daemon[15386]: Leaving mDNS multicast group on interface wlp3s0.IPv4 with address 10.10.10.100.
Aug  5 19:37:57 Joanie avahi-daemon[15386]: Interface wlp3s0.IPv4 no longer relevant for mDNS.
Aug  5 19:37:57 Joanie NetworkManager[866]: <info>  [1533512277.5582] dns-mgr: Writing DNS information to /sbin/resolvconf
Aug  5 19:37:57 Joanie kernel: [8615319.113615] wlp3s0: deauthenticating from c0:8a:de:20:2f:68 by local choice (Reason: 3=DEAUTH_LEAVING)
Aug  5 19:37:57 Joanie avahi-daemon[15386]: Withdrawing address record for fe80::bf52:2694:756c:4265 on wlp3s0.
Aug  5 19:37:57 Joanie avahi-daemon[15386]: Leaving mDNS multicast group on interface wlp3s0.IPv6 with address fe80::bf52:2694:756c:4265.
Aug  5 19:37:57 Joanie dnsmasq[1324]: setting upstream servers from DBus
Aug  5 19:37:57 Joanie org.gtk.vfs.Daemon[1873]: ** (process:3196): WARNING **: Couldn't create directory monitor on smb://x-gnome-default-workgroup/. Error: Operation not supported by backend
Aug  5 19:37:57 Joanie wpa_supplicant[1135]: wlp3s0: CTRL-EVENT-DISCONNECTED bssid=c0:8a:de:20:2f:68 reason=3 locally_generated=1
Aug  5 19:37:57 Joanie avahi-daemon[15386]: Interface wlp3s0.IPv6 no longer relevant for mDNS.
Aug  5 19:37:57 Joanie wpa_supplicant[1135]: wlp3s0: CTRL-EVENT-REGDOM-CHANGE init=CORE type=WORLD
Aug  5 19:37:57 Joanie kernel: [8615319.127417] cfg80211: World regulatory domain updated:
Aug  5 19:37:57 Joanie kernel: [8615319.127422] cfg80211:  DFS Master region: unset
Aug  5 19:37:57 Joanie kernel: [8615319.127424] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
Aug  5 19:37:57 Joanie kernel: [8615319.127428] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
Aug  5 19:37:57 Joanie kernel: [8615319.127430] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
Aug  5 19:37:57 Joanie kernel: [8615319.127432] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
Aug  5 19:37:57 Joanie kernel: [8615319.127435] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (N/A)
Aug  5 19:37:57 Joanie kernel: [8615319.127438] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (0 s)
Aug  5 19:37:57 Joanie kernel: [8615319.127440] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
Aug  5 19:37:57 Joanie kernel: [8615319.127443] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
Aug  5 19:37:57 Joanie kernel: [8615319.127445] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
Aug  5 19:37:57 Joanie org.gtk.vfs.Daemon[1873]: ** (process:3196): WARNING **: Couldn't create directory monitor on smb://x-gnome-default-workgroup/. Error: Operation not supported by backend
Aug  5 19:37:57 Joanie NetworkManager[866]: <info>  [1533512277.5828] manager: NetworkManager state is now ASLEEP
Aug  5 19:37:57 Joanie dbus[850]: [system] Activating via systemd: service name='org.freedesktop.nm_dispatcher' unit='dbus-org.freedesktop.nm-dispatcher.service'
Aug  5 19:37:57 Joanie systemd[1]: Reached target Sleep.
Aug  5 19:37:57 Joanie systemd[1]: Starting Suspend...
Aug  5 19:37:57 Joanie systemd[1]: Starting Network Manager Script Dispatcher Service...
Aug  5 19:37:57 Joanie wpa_supplicant[1135]: nl80211: deinit ifname=wlp3s0 disabled_11b_rates=0
Aug  5 19:37:57 Joanie dbus[850]: [system] Successfully activated service 'org.freedesktop.nm_dispatcher'
Aug  5 19:37:57 Joanie systemd[1]: Started Network Manager Script Dispatcher Service.
Aug  5 19:37:57 Joanie nm-dispatcher: req:1 'down' [wlp3s0]: new request (1 scripts)
Aug  5 19:37:57 Joanie nm-dispatcher: req:1 'down' [wlp3s0]: start running ordered scripts...
Aug  5 19:37:59 Joanie ntpd[14595]: Deleting interface #36 wlp3s0, 10.10.10.100#123, interface stats: received=126, sent=127, dropped=0, active_time=949 secs
Aug  5 19:37:59 Joanie ntpd[14595]: 198.55.111.50 local addr 10.10.10.100 -> <null>
Aug  5 19:37:59 Joanie ntpd[14595]: 103.105.51.156 local addr 10.10.10.100 -> <null>
Aug  5 19:37:59 Joanie ntpd[14595]: 98.191.213.14 local addr 10.10.10.100 -> <null>
Aug  5 19:37:59 Joanie ntpd[14595]: 129.6.15.30 local addr 10.10.10.100 -> <null>
Aug  5 19:37:59 Joanie ntpd[14595]: 129.6.15.28 local addr 10.10.10.100 -> <null>
Aug  5 19:37:59 Joanie ntpd[14595]: 216.93.242.12 local addr 10.10.10.100 -> <null>
Aug  5 19:37:59 Joanie ntpd[14595]: 12.167.151.1 local addr 10.10.10.100 -> <null>
Aug  5 19:37:59 Joanie ntpd[14595]: 128.10.19.24 local addr 10.10.10.100 -> <null>
Aug  5 19:37:59 Joanie ntpd[14595]: 162.221.74.15 local addr 10.10.10.100 -> <null>
Aug  5 19:37:59 Joanie ntpd[14595]: 45.56.105.98 local addr 10.10.10.100 -> <null>
Aug  5 19:37:59 Joanie ntpd[14595]: 108.61.73.244 local addr 10.10.10.100 -> <null>
Aug  5 19:37:59 Joanie ntpd[14595]: 216.229.0.50 local addr 10.10.10.100 -> <null>
Aug  5 19:37:59 Joanie ntpd[14595]: 45.63.11.93 local addr 10.10.10.100 -> <null>
Aug  5 19:37:59 Joanie ntpd[14595]: 140.82.7.153 local addr 10.10.10.100 -> <null>
Aug  5 19:37:59 Joanie ntpd[14595]: 69.164.201.245 local addr 10.10.10.100 -> <null>
Aug  5 19:37:59 Joanie ntpd[14595]: 66.207.226.14 local addr 10.10.10.100 -> <null>
Aug  5 19:37:59 Joanie ntpd[14595]: Deleting interface #38 wlp3s0, fe80::bf52:2694:756c:4265%3#123, interface stats: received=0, sent=0, dropped=0, active_time=947 secs
Aug  5 19:38:07 Joanie systemd-sleep[17527]: Selected interface 'wlp3s0'
Aug  5 19:38:07 Joanie systemd-sleep[17527]: 'SUSPEND' command timed out.
Aug  5 19:38:07 Joanie systemd-sleep[17532]: /lib/systemd/system-sleep/wpasupplicant failed with error code 254.
Aug  5 19:38:07 Joanie systemd-sleep[17527]: Suspending system...
Aug  7 22:04:21 Joanie kernel: [8615329.187302] PM: Syncing filesystems ... done.
Aug  7 22:04:21 Joanie kernel: [8615329.202911] PM: Preparing system for sleep (mem)
Aug  7 22:04:21 Joanie kernel: [8615329.203231] Freezing user space processes ... (elapsed 0.002 seconds) done.
Aug  7 22:04:21 Joanie kernel: [8615329.205413] Freezing remaining freezable tasks ... (elapsed 0.077 seconds) done.
Aug  7 22:04:21 Joanie kernel: [8615329.282787] PM: Suspending system (mem)
Aug  7 22:04:21 Joanie kernel: [8615329.282870] Suspending console(s) (use no_console_suspend to debug)
Aug  7 22:04:21 Joanie kernel: [8615329.441006] sd 0:0:0:0: [sda] Synchronizing SCSI cache
Aug  7 22:04:21 Joanie kernel: [8615329.441853] sd 0:0:0:0: [sda] Stopping disk
Aug  7 22:04:21 Joanie kernel: [8615329.720286] PM: suspend of devices complete after 437.221 msecs
Aug  7 22:04:21 Joanie kernel: [8615329.733391] PM: late suspend of devices complete after 13.101 msecs
Aug  7 22:04:21 Joanie kernel: [8615329.734814] r8169 0000:09:00.0: System wakeup enabled by ACPI
Aug  7 22:04:21 Joanie kernel: [8615329.734892] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
Aug  7 22:04:21 Joanie kernel: [8615329.735164] ehci-pci 0000:00:1a.0: System wakeup enabled by ACPI
Aug  7 22:04:21 Joanie kernel: [8615329.749424] PM: noirq suspend of devices complete after 16.029 msecs
Aug  7 22:04:21 Joanie kernel: [8615329.749589] ACPI: Preparing to enter system sleep state S3
Aug  7 22:04:21 Joanie kernel: [8615329.929543] ACPI : EC: EC stopped
Aug  7 22:04:21 Joanie kernel: [8615329.929544] PM: Saving platform NVS memory
Aug  7 22:04:21 Joanie kernel: [8615329.930434] Disabling non-boot CPUs ...
Aug  7 22:04:21 Joanie kernel: [8615329.931867] smpboot: CPU 1 is now offline
Aug  7 22:04:21 Joanie kernel: [8615329.942216] Broke affinity for irq 16
Aug  7 22:04:21 Joanie kernel: [8615329.942227] Broke affinity for irq 23
Aug  7 22:04:21 Joanie kernel: [8615329.942231] Broke affinity for irq 25
Aug  7 22:04:21 Joanie kernel: [8615329.943276] smpboot: CPU 2 is now offline
Aug  7 22:04:21 Joanie kernel: [8615329.954304] Broke affinity for irq 1
Aug  7 22:04:21 Joanie kernel: [8615329.954314] Broke affinity for irq 9
Aug  7 22:04:21 Joanie kernel: [8615329.954321] Broke affinity for irq 12
Aug  7 22:04:21 Joanie kernel: [8615329.954327] Broke affinity for irq 16
Aug  7 22:04:21 Joanie kernel: [8615329.954338] Broke affinity for irq 23
Aug  7 22:04:21 Joanie kernel: [8615329.954342] Broke affinity for irq 24
Aug  7 22:04:21 Joanie kernel: [8615329.954344] Broke affinity for irq 25
Aug  7 22:04:21 Joanie kernel: [8615329.954347] Broke affinity for irq 26
Aug  7 22:04:21 Joanie kernel: [8615329.954349] Broke affinity for irq 29
Aug  7 22:04:21 Joanie kernel: [8615329.955397] smpboot: CPU 3 is now offline
Aug  7 22:04:21 Joanie kernel: [8615329.970836] ACPI: Low-level resume complete
Aug  7 22:04:21 Joanie kernel: [8615329.970896] ACPI : EC: EC started
Aug  7 22:04:21 Joanie kernel: [8615329.970897] PM: Restoring platform NVS memory
Aug  7 22:04:21 Joanie kernel: [8615329.971462] Enabling non-boot CPUs ...
Aug  7 22:04:21 Joanie kernel: [8615329.990823] x86: Booting SMP configuration:
Aug  7 22:04:21 Joanie kernel: [8615329.990823] smpboot: Booting Node 0 Processor 1 APIC 0x4
Aug  7 22:04:21 Joanie kernel: [8615329.993430]  cache: parent cpu1 should not be sleeping
Aug  7 22:04:21 Joanie kernel: [8615329.993671] CPU1 is up
Aug  7 22:04:21 Joanie kernel: [8615330.010850] smpboot: Booting Node 0 Processor 2 APIC 0x1
Aug  7 22:04:21 Joanie kernel: [8615330.013333]  cache: parent cpu2 should not be sleeping
Aug  7 22:04:21 Joanie kernel: [8615330.013573] CPU2 is up
Aug  7 22:04:21 Joanie kernel: [8615330.030886] smpboot: Booting Node 0 Processor 3 APIC 0x5
Aug  7 22:04:21 Joanie kernel: [8615330.033403]  cache: parent cpu3 should not be sleeping
Aug  7 22:04:21 Joanie kernel: [8615330.033646] CPU3 is up
Aug  7 22:04:21 Joanie kernel: [8615330.036232] ACPI: Waking up from system sleep state S3
Aug  7 22:04:21 Joanie kernel: [8615330.223100] ehci-pci 0000:00:1a.0: System wakeup disabled by ACPI
Aug  7 22:04:21 Joanie kernel: [8615330.223174] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
Aug  7 22:04:21 Joanie kernel: [8615330.223330] PM: noirq resume of devices complete after 16.601 msecs
Aug  7 22:04:21 Joanie kernel: [8615330.225461] PM: early resume of devices complete after 2.108 msecs
Aug  7 22:04:21 Joanie kernel: [8615330.225739] r8169 0000:09:00.0: System wakeup disabled by ACPI
Aug  7 22:04:21 Joanie kernel: [8615330.226920] sd 0:0:0:0: [sda] Starting disk
Aug  7 22:04:21 Joanie kernel: [8615330.280161] r8169 0000:09:00.0 enp9s0: link down
Aug  7 22:04:21 Joanie kernel: [8615330.335527] rtc_cmos 00:02: System wakeup disabled by ACPI
Aug  7 22:04:21 Joanie kernel: [8615330.454703] usb 1-1.3: reset full-speed USB device number 3 using ehci-pci
Aug  7 22:04:21 Joanie kernel: [8615330.458639] usb 2-1.4: reset high-speed USB device number 3 using ehci-pci
Aug  7 22:04:21 Joanie kernel: [8615330.546671] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug  7 22:04:21 Joanie kernel: [8615330.546953] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
Aug  7 22:04:21 Joanie kernel: [8615330.546955] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
Aug  7 22:04:21 Joanie kernel: [8615330.547563] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
Aug  7 22:04:21 Joanie kernel: [8615330.547568] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
Aug  7 22:04:21 Joanie kernel: [8615330.547715] ata1.00: configured for UDMA/133
Aug  7 22:04:21 Joanie kernel: [8615330.554651] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Aug  7 22:04:21 Joanie kernel: [8615330.555248] ata2.00: unexpected _GTF length (8)
Aug  7 22:04:21 Joanie kernel: [8615330.556729] ata2.00: unexpected _GTF length (8)
Aug  7 22:04:21 Joanie kernel: [8615330.556733] ata2.00: configured for UDMA/100
Aug  7 22:04:21 Joanie kernel: [8615330.562665] ata5: SATA link down (SStatus 0 SControl 300)
Aug  7 22:04:21 Joanie kernel: [8615330.570690] ata6: SATA link down (SStatus 0 SControl 300)
Aug  7 22:04:21 Joanie kernel: [8615330.618653] usb 1-1.6: reset full-speed USB device number 5 using ehci-pci
Aug  7 22:04:21 Joanie kernel: [8615330.622648] usb 2-1.2: reset high-speed USB device number 7 using ehci-pci
Aug  7 22:04:21 Joanie kernel: [8615330.720011] PM: resume of devices complete after 494.574 msecs
Aug  7 22:04:21 Joanie kernel: [8615330.720749] PM: Finishing wakeup.
Aug  7 22:04:21 Joanie kernel: [8615330.720750] Restarting tasks ... done.
Aug  7 22:04:21 Joanie systemd[1]: Time has been changed
Aug  7 22:04:21 Joanie systemd[1806]: Time has been changed
Aug  7 22:04:21 Joanie bluetoothd[23268]: Failed to obtain handles for "Service Changed" characteristic
Aug  7 22:04:21 Joanie bluetoothd[23268]: Not enough free handles to register service
Aug  7 22:04:21 Joanie bluetoothd[23268]: Error adding Link Loss service
Aug  7 22:04:21 Joanie bluetoothd[23268]: Not enough free handles to register service
Aug  7 22:04:21 Joanie bluetoothd[23268]: message repeated 2 times: [ Not enough free handles to register service]
Aug  7 22:04:21 Joanie bluetoothd[23268]: Current Time Service could not be registered
Aug  7 22:04:21 Joanie bluetoothd[23268]: gatt-time-server: Input/output error (5)
Aug  7 22:04:21 Joanie bluetoothd[23268]: Not enough free handles to register service
Aug  7 22:04:21 Joanie bluetoothd[23268]: Not enough free handles to register service
Aug  7 22:04:21 Joanie bluetoothd[23268]: Sap driver initialization failed.
Aug  7 22:04:21 Joanie bluetoothd[23268]: sap-server: Operation not permitted (1)
Aug  7 22:04:21 Joanie systemd-sleep[17527]: System resumed.
Aug  7 22:04:21 Joanie kernel: [8615330.788852] video LNXVIDEO:01: Restoring backlight state
Aug  7 22:04:21 Joanie systemd-sleep[17527]: Failed to connect to non-global ctrl_ifname: (nil)  error: No such file or directory
Aug  7 22:04:21 Joanie systemd-sleep[17681]: /lib/systemd/system-sleep/wpasupplicant failed with error code 255.
Aug  7 22:04:22 Joanie systemd-sleep[17527]: /dev/sda:
Aug  7 22:04:22 Joanie systemd-sleep[17527]:  setting Advanced Power Management level to 0x80 (128)
Aug  7 22:04:22 Joanie systemd-sleep[17527]:  APM_level#011= 128
Aug  7 22:04:22 Joanie systemd[1]: Starting Load/Save RF Kill Switch Status...
Aug  7 22:04:22 Joanie systemd[1]: Started Load/Save RF Kill Switch Status.
Aug  7 22:04:22 Joanie systemd[1]: bluetooth.target: Unit not needed anymore. Stopping.
Aug  7 22:04:22 Joanie systemd[1]: Stopped target Bluetooth.
Aug  7 22:04:22 Joanie systemd-sleep[17527]: /dev/sda:
Aug  7 22:04:22 Joanie systemd-sleep[17527]:  setting standby to 36 (3 minutes)
Aug  7 22:04:22 Joanie systemd[1]: Started Suspend.
Aug  7 22:04:22 Joanie systemd[1]: sleep.target: Unit not needed anymore. Stopping.
Aug  7 22:04:22 Joanie systemd[1]: Stopped target Sleep.
Aug  7 22:04:22 Joanie systemd[1]: Reached target Suspend.
Aug  7 22:04:22 Joanie systemd[1]: suspend.target: Unit is bound to inactive unit systemd-suspend.service. Stopping, too.
Aug  7 22:04:22 Joanie systemd[1]: Stopped target Suspend.
Aug  7 22:04:22 Joanie kernel: [8615331.157412] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
Aug  7 22:04:22 Joanie kernel: [8615331.158662] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.2646] manager: wake requested (sleeping: yes  enabled: yes)
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.2647] manager: waking up...
Aug  7 22:04:22 Joanie kernel: [8615331.166340] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  7 22:04:22 Joanie kernel: [8615331.166442] iwlwifi 0000:03:00.0: Radio type=0x0-0x0-0x3
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.2648] device (enp9s0): state change: unavailable -> unmanaged (reason 'sleeping') [20 10 37]
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.2856] device (wlp3s0): state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
Aug  7 22:04:22 Joanie systemd[1]: Started Run anacron jobs at resume.
Aug  7 22:04:22 Joanie kernel: [8615331.205759] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  7 22:04:22 Joanie kernel: [8615331.213261] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
Aug  7 22:04:22 Joanie kernel: [8615331.213361] iwlwifi 0000:03:00.0: Radio type=0x0-0x0-0x3
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.3819] device (enp9s0): state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
Aug  7 22:04:22 Joanie kernel: [8615331.251722] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
Aug  7 22:04:22 Joanie kernel: [8615331.254070] IPv6: ADDRCONF(NETDEV_UP): enp9s0: link is not ready
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.4373] manager: NetworkManager state is now DISCONNECTED
Aug  7 22:04:22 Joanie kernel: [8615331.307872] r8169 0000:09:00.0 enp9s0: link down
Aug  7 22:04:22 Joanie kernel: [8615331.307939] IPv6: ADDRCONF(NETDEV_UP): enp9s0: link is not ready
Aug  7 22:04:22 Joanie wpa_supplicant[1135]: dbus: wpa_dbus_get_object_properties: failed to get object properties: (none) none
Aug  7 22:04:22 Joanie wpa_supplicant[1135]: dbus: Failed to construct signal
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.4936] device (wlp3s0): supplicant interface state: starting -> ready
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.4937] device (wlp3s0): state change: unavailable -> disconnected (reason 'supplicant-available') [20 30 42]
Aug  7 22:04:22 Joanie kernel: [8615331.365575] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
Aug  7 22:04:22 Joanie kernel: [8615331.379565] psmouse serio4: synaptics: queried max coordinates: x [..5856], y [..4938]
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.9592] device (wlp3s0): supplicant interface state: ready -> inactive
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.9649] policy: auto-activating connection 'VoicePlex'
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.9664] device (wlp3s0): Activation: starting connection 'VoicePlex' (cf0aa26d-621a-4742-bf42-0b0a1644f3ca)
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.9669] device (wlp3s0): state change: disconnected -> prepare (reason 'none') [30 40 0]
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.9673] manager: NetworkManager state is now CONNECTING
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.9683] device (wlp3s0): state change: prepare -> config (reason 'none') [40 50 0]
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.9688] device (wlp3s0): Activation: (wifi) access point 'VoicePlex' has security, but secrets are required.
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.9688] device (wlp3s0): state change: config -> need-auth (reason 'none') [50 60 0]
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.9741] device (wlp3s0): state change: need-auth -> prepare (reason 'none') [60 40 0]
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.9747] device (wlp3s0): state change: prepare -> config (reason 'none') [40 50 0]
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.9750] device (wlp3s0): Activation: (wifi) connection 'VoicePlex' has security, and secrets exist.  No new secrets needed.
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.9751] Config: added 'ssid' value 'VoicePlex'
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.9752] Config: added 'scan_ssid' value '1'
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.9752] Config: added 'key_mgmt' value 'WPA-PSK'
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.9752] Config: added 'auth_alg' value 'OPEN'
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.9752] Config: added 'psk' value '<omitted>'
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.9786] sup-iface[0xa9d790,wlp3s0]: config: set interface ap_scan to 1
Aug  7 22:04:22 Joanie wpa_supplicant[1135]: wlp3s0: SME: Trying to authenticate with c0:8a:de:20:2f:68 (SSID='VoicePlex' freq=2412 MHz)
Aug  7 22:04:22 Joanie kernel: [8615331.863820] wlp3s0: authenticate with c0:8a:de:20:2f:68
Aug  7 22:04:22 Joanie kernel: [8615331.865403] wlp3s0: send auth to c0:8a:de:20:2f:68 (try 1/3)
Aug  7 22:04:22 Joanie wpa_supplicant[1135]: wlp3s0: Trying to associate with c0:8a:de:20:2f:68 (SSID='VoicePlex' freq=2412 MHz)
Aug  7 22:04:22 Joanie NetworkManager[866]: <info>  [1533693862.9982] device (wlp3s0): supplicant interface state: inactive -> associating
Aug  7 22:04:22 Joanie kernel: [8615331.866932] wlp3s0: authenticated
Aug  7 22:04:22 Joanie kernel: [8615331.870508] wlp3s0: associate with c0:8a:de:20:2f:68 (try 1/3)
Aug  7 22:04:23 Joanie kernel: [8615331.874535] wlp3s0: RX AssocResp from c0:8a:de:20:2f:68 (capab=0x431 status=0 aid=1)
Aug  7 22:04:23 Joanie kernel: [8615331.877965] wlp3s0: associated
Aug  7 22:04:23 Joanie kernel: [8615331.878039] IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s0: link becomes ready
Aug  7 22:04:23 Joanie wpa_supplicant[1135]: wlp3s0: Associated with c0:8a:de:20:2f:68
Aug  7 22:04:23 Joanie wpa_supplicant[1135]: wlp3s0: WPA: Key negotiation completed with c0:8a:de:20:2f:68 [PTK=CCMP GTK=CCMP]
Aug  7 22:04:23 Joanie wpa_supplicant[1135]: wlp3s0: CTRL-EVENT-CONNECTED - Connection to c0:8a:de:20:2f:68 completed [id=0 id_str=]
Aug  7 22:04:23 Joanie NetworkManager[866]: <info>  [1533693863.0151] device (wlp3s0): supplicant interface state: associating -> completed
Aug  7 22:04:23 Joanie NetworkManager[866]: <info>  [1533693863.0152] device (wlp3s0): Activation: (wifi) Stage 2 of 5 (Device Configure) successful.  Connected to wireless network 'VoicePlex'.
Aug  7 22:04:23 Joanie NetworkManager[866]: <info>  [1533693863.0154] device (wlp3s0): state change: config -> ip-config (reason 'none') [50 70 0]
Aug  7 22:04:23 Joanie NetworkManager[866]: <info>  [1533693863.0160] dhcp4 (wlp3s0): activation: beginning transaction (timeout in 45 seconds)
Aug  7 22:04:23 Joanie NetworkManager[866]: <info>  [1533693863.0189] dhcp4 (wlp3s0): dhclient started with pid 17739
Aug  7 22:04:23 Joanie dhclient[17739]: DHCPDISCOVER on wlp3s0 to 255.255.255.255 port 67 interval 3 (xid=0xd2991569)
Aug  7 22:04:23 Joanie dhclient[17739]: DHCPREQUEST of 10.10.10.100 on wlp3s0 to 255.255.255.255 port 67 (xid=0x691599d2)
Aug  7 22:04:23 Joanie dhclient[17739]: DHCPOFFER of 10.10.10.100 from 10.10.10.254
Aug  7 22:04:23 Joanie dhclient[17739]: DHCPACK of 10.10.10.100 from 10.10.10.254
Aug  7 22:04:23 Joanie NetworkManager[866]: <info>  [1533693863.4858]   address 10.10.10.100
Aug  7 22:04:23 Joanie NetworkManager[866]: <info>  [1533693863.4859]   plen 24 (255.255.255.0)
Aug  7 22:04:23 Joanie NetworkManager[866]: <info>  [1533693863.4859]   gateway 10.10.10.254
Aug  7 22:04:23 Joanie NetworkManager[866]: <info>  [1533693863.4859]   server identifier 10.10.10.254
Aug  7 22:04:23 Joanie NetworkManager[866]: <info>  [1533693863.4859]   lease time 86400
Aug  7 22:04:23 Joanie NetworkManager[866]: <info>  [1533693863.4860]   hostname 'Joanie'
Aug  7 22:04:23 Joanie NetworkManager[866]: <info>  [1533693863.4860]   nameserver '10.10.10.254'
Aug  7 22:04:23 Joanie avahi-daemon[15386]: Joining mDNS multicast group on interface wlp3s0.IPv4 with address 10.10.10.100.
Aug  7 22:04:23 Joanie NetworkManager[866]: <info>  [1533693863.4860] dhcp4 (wlp3s0): state changed unknown -> bound
Aug  7 22:04:23 Joanie avahi-daemon[15386]: New relevant interface wlp3s0.IPv4 for mDNS.
Aug  7 22:04:23 Joanie avahi-daemon[15386]: Registering new address record for 10.10.10.100 on wlp3s0.IPv4.
Aug  7 22:04:23 Joanie NetworkManager[866]: <info>  [1533693863.4891] device (wlp3s0): state change: ip-config -> ip-check (reason 'none') [70 80 0]
Aug  7 22:04:23 Joanie NetworkManager[866]: <info>  [1533693863.4900] device (wlp3s0): state change: ip-check -> secondaries (reason 'none') [80 90 0]
Aug  7 22:04:23 Joanie NetworkManager[866]: <info>  [1533693863.4906] device (wlp3s0): state change: secondaries -> activated (reason 'none') [90 100 0]
Aug  7 22:04:23 Joanie NetworkManager[866]: <info>  [1533693863.4909] manager: NetworkManager state is now CONNECTED_LOCAL
Aug  7 22:04:23 Joanie dhclient[17739]: bound to 10.10.10.100 -- renewal in 39914 seconds.
Aug  7 22:04:23 Joanie NetworkManager[866]: <info>  [1533693863.5024] manager: NetworkManager state is now CONNECTED_GLOBAL
Aug  7 22:04:23 Joanie NetworkManager[866]: <info>  [1533693863.5026] policy: set 'VoicePlex' (wlp3s0) as default for IPv4 routing and DNS
Aug  7 22:04:23 Joanie NetworkManager[866]: <info>  [1533693863.5028] dns-mgr: Writing DNS information to /sbin/resolvconf
Aug  7 22:04:23 Joanie dnsmasq[1324]: setting upstream servers from DBus
Aug  7 22:04:23 Joanie dnsmasq[1324]: using nameserver 10.10.10.254#53
Aug  7 22:04:23 Joanie NetworkManager[866]: <info>  [1533693863.5129] device (wlp3s0): Activation: successful, device activated.
Aug  7 22:04:23 Joanie dbus[850]: [system] Activating via systemd: service name='org.freedesktop.nm_dispatcher' unit='dbus-org.freedesktop.nm-dispatcher.service'
Aug  7 22:04:23 Joanie systemd[1]: Starting Network Manager Script Dispatcher Service...
Aug  7 22:04:23 Joanie dbus[850]: [system] Successfully activated service 'org.freedesktop.nm_dispatcher'
Aug  7 22:04:23 Joanie systemd[1]: Started Network Manager Script Dispatcher Service.
Aug  7 22:04:23 Joanie nm-dispatcher: req:1 'up' [wlp3s0]: new request (1 scripts)
Aug  7 22:04:23 Joanie nm-dispatcher: req:1 'up' [wlp3s0]: start running ordered scripts...
Aug  7 22:04:23 Joanie org.gtk.vfs.Daemon[1873]: ** (process:3196): WARNING **: Couldn't create directory monitor on smb://x-gnome-default-workgroup/. Error: Operation not supported by backend
Aug  7 22:04:23 Joanie org.gtk.vfs.Daemon[1873]: message repeated 2 times: [ ** (process:3196): WARNING **: Couldn't create directory monitor on smb://x-gnome-default-workgroup/. Error: Operation not supported by backend]
Aug  7 22:04:23 Joanie ntpdate[17791]: the NTP socket is in use, exiting
Aug  7 22:04:24 Joanie avahi-daemon[15386]: Joining mDNS multicast group on interface wlp3s0.IPv6 with address fe80::bf52:2694:756c:4265.
Aug  7 22:04:24 Joanie avahi-daemon[15386]: New relevant interface wlp3s0.IPv6 for mDNS.
Aug  7 22:04:24 Joanie avahi-daemon[15386]: Registering new address record for fe80::bf52:2694:756c:4265 on wlp3s0.*.
Aug  7 22:04:25 Joanie ntpd[14595]: Listen normally on 39 wlp3s0 10.10.10.100:123
Aug  7 22:04:25 Joanie ntpd[14595]: Listen normally on 40 wlp3s0 [fe80::bf52:2694:756c:4265%3]:123
Aug  7 22:04:25 Joanie ntpd[14595]: new interface(s) found: waking up resolver
Aug  7 22:04:38 Joanie kernel: [8615347.321596] usb 1-1.1: new high-speed USB device number 16 using ehci-pci
Aug  7 22:04:38 Joanie kernel: [8615347.420262] usb 1-1.1: New USB device found, idVendor=090c, idProduct=1000
Aug  7 22:04:38 Joanie kernel: [8615347.420271] usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Aug  7 22:04:38 Joanie kernel: [8615347.420276] usb 1-1.1: Product: Flash Drive
Aug  7 22:04:38 Joanie kernel: [8615347.420281] usb 1-1.1: Manufacturer: Samsung
Aug  7 22:04:38 Joanie kernel: [8615347.420286] usb 1-1.1: SerialNumber: 0375717070007140
Aug  7 22:04:38 Joanie kernel: [8615347.421628] usb-storage 1-1.1:1.0: USB Mass Storage device detected
Aug  7 22:04:38 Joanie kernel: [8615347.422626] scsi host17: usb-storage 1-1.1:1.0
Aug  7 22:04:38 Joanie mtp-probe: checking bus 1, device 16: "/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.1"
Aug  7 22:04:38 Joanie mtp-probe: bus: 1, device: 16 was not an MTP device
Aug  7 22:04:39 Joanie kernel: [8615348.641649] scsi 17:0:0:0: Direct-Access     Samsung  Flash Drive      1100 PQ: 0 ANSI: 6
Aug  7 22:04:39 Joanie kernel: [8615348.642455] sd 17:0:0:0: Attached scsi generic sg2 type 0
Aug  7 22:04:39 Joanie kernel: [8615348.643301] sd 17:0:0:0: [sdb] 62668800 512-byte logical blocks: (32.1 GB/29.9 GiB)
Aug  7 22:04:39 Joanie kernel: [8615348.644314] sd 17:0:0:0: [sdb] Write Protect is off
Aug  7 22:04:39 Joanie kernel: [8615348.644325] sd 17:0:0:0: [sdb] Mode Sense: 43 00 00 00
Aug  7 22:04:39 Joanie kernel: [8615348.645492] sd 17:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Aug  7 22:04:39 Joanie kernel: [8615348.654238]  sdb: sdb1
Aug  7 22:04:39 Joanie kernel: [8615348.658970] sd 17:0:0:0: [sdb] Attached SCSI removable disk
Aug  7 22:04:52 Joanie udisksd[2007]: Mounted /dev/sdb1 at /media/dkosek/Samsung USB on behalf of uid 1000
Aug  7 22:14:07 Joanie udisksd[2007]: Cleaning up mount point /media/dkosek/Samsung USB (device 8:17 is not mounted)
Aug  7 22:14:07 Joanie udisksd[2007]: Unmounted /dev/sdb1 on behalf of uid 1000
Aug  7 22:14:10 Joanie kernel: [8615919.504367] usb 1-1.1: USB disconnect, device number 16
Aug  7 22:17:01 Joanie CRON[18680]: (root) CMD (   cd / && run-parts --report /etc/cron.hourly)
Aug  7 22:20:22 Joanie kernel: [8616291.135192] usb 1-1.1: new high-speed USB device number 17 using ehci-pci
Aug  7 22:20:22 Joanie kernel: [8616291.238279] usb 1-1.1: New USB device found, idVendor=090c, idProduct=1000
Aug  7 22:20:22 Joanie kernel: [8616291.238292] usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Aug  7 22:20:22 Joanie kernel: [8616291.238296] usb 1-1.1: Product: Flash Drive
Aug  7 22:20:22 Joanie kernel: [8616291.238299] usb 1-1.1: Manufacturer: Samsung
Aug  7 22:20:22 Joanie kernel: [8616291.238303] usb 1-1.1: SerialNumber: 0375717070007140
Aug  7 22:20:22 Joanie kernel: [8616291.239483] usb-storage 1-1.1:1.0: USB Mass Storage device detected
Aug  7 22:20:22 Joanie kernel: [8616291.240188] scsi host18: usb-storage 1-1.1:1.0
Aug  7 22:20:22 Joanie mtp-probe: checking bus 1, device 17: "/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.1"
Aug  7 22:20:22 Joanie mtp-probe: bus: 1, device: 17 was not an MTP device
Aug  7 22:20:23 Joanie kernel: [8616292.459706] scsi 18:0:0:0: Direct-Access     Samsung  Flash Drive      1100 PQ: 0 ANSI: 6
Aug  7 22:20:23 Joanie kernel: [8616292.460558] sd 18:0:0:0: Attached scsi generic sg2 type 0
Aug  7 22:20:23 Joanie kernel: [8616292.461490] sd 18:0:0:0: [sdb] 62668800 512-byte logical blocks: (32.1 GB/29.9 GiB)
Aug  7 22:20:23 Joanie kernel: [8616292.462628] sd 18:0:0:0: [sdb] Write Protect is off
Aug  7 22:20:23 Joanie kernel: [8616292.462637] sd 18:0:0:0: [sdb] Mode Sense: 43 00 00 00
Aug  7 22:20:23 Joanie kernel: [8616292.465337] sd 18:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Aug  7 22:20:23 Joanie kernel: [8616292.472388]  sdb: sdb1
Aug  7 22:20:23 Joanie kernel: [8616292.477381] sd 18:0:0:0: [sdb] Attached SCSI removable disk
Aug  7 22:20:59 Joanie udisksd[2007]: Mounted /dev/sdb1 at /media/dkosek/Samsung USB on behalf of uid 1000

--Apple-Mail=_05342D18-2BFB-4528-B1B0-59A5380BD521
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8



> On Aug 7, 2018, at 5:41 PM, Dan Kosek <daniel.kosek@gmail.com> wrote:
>=20
> Here are the Raspberry Pi 3B log files.
>=20
> I will be sending the one from the test laptop I have later this =
evening.
>=20
> Dan
>=20
> Dan Kosek
> daniel.kosek@gmail.com
> <Raspberry Pi 3B Log Files.zip>
>=20
>> On Aug 6, 2018, at 5:17 AM, Arend van Spriel =
<arend.vanspriel@broadcom.com> wrote:
>>=20
>> + linux-wireless
>>=20
>> On 8/5/2018 4:59 AM, Dan Kosek wrote:
>>> Arend,
>>>=20
>>> Thank you for getting back to me.  Adding the =E2=80=9Cflush=E2=80=9D =
variable to the command fixes the issue on both systems.  Wow is the =
single channel scan fast with the flush.  Is appears the full scan (all =
channels) is faster with the flush option as well.
>>=20
>> Glad it worked for you.
>>=20
>>> I have attached my bash logs.
>>>=20
>>> No I have don=E2=80=99t have kernel logfiles.
>>>=20
>>> I would be glad to collect the kernel log files for you tomorrow.
>>=20
>> There is not really an issue here so no need.
>>=20
>>> Can you provide me some instructions or a reference and I will =
forward them.
>>> 	(I am a wireless engineer my trade and learning to program now.)
>>=20
>> Welcome to the dark side :-p Getting the logs depends on you linux =
distro, but using dmesg tends to work on most of them.
>>=20
>> Regards,
>> Arend
>>=20
>=20


--Apple-Mail=_05342D18-2BFB-4528-B1B0-59A5380BD521--
